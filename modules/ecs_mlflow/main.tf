data "aws_region" "current" {}
data "aws_iam_policy_document" "task_assume" { statement { actions = ["sts:AssumeRole"] principals { type = "Service" identifiers = ["ecs-tasks.amazonaws.com"] } } }
resource "aws_iam_role" "task_role" { name = "${var.name}-mlflow-task-role" assume_role_policy = data.aws_iam_policy_document.task_assume.json }
resource "aws_iam_role_policy" "s3_access" {
  role = aws_iam_role.task_role.id
  policy = jsonencode({ Version="2012-10-17", Statement=[{Effect="Allow", Action=["s3:*"], Resource=[var.artifacts_bucket_arn, "${var.artifacts_bucket_arn}/*"]}] })
}

resource "aws_ecs_cluster" "this" { name = "${var.name}-cluster" }
resource "aws_cloudwatch_log_group" "lg" { name = "/ecs/${var.name}-mlflow" retention_in_days = 30 }

resource "aws_ecs_task_definition" "mlflow" {
  family = "${var.name}-mlflow-td"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 512
  memory = 1024
  execution_role_arn = var.exec_role_arn
  task_role_arn = aws_iam_role.task_role.arn
  container_definitions = jsonencode([{
    name  = "mlflow"
    image = var.mlflow_image
    portMappings = [{ containerPort = 5000, protocol = "tcp" }]
    environment = [
      { name = "BACKEND_URI",  value = "postgresql+psycopg2://${var.db_user}:${var.db_pass}@${var.db_host}:${var.db_port}/${var.db_name}" },
      { name = "ARTIFACT_ROOT", value = "s3://${var.artifacts_bucket}/mlflow/" }
    ]
    command = ["mlflow","server","--backend-store-uri","$(BACKEND_URI)","--artifacts-destination","$(ARTIFACT_ROOT)","--host","0.0.0.0","--port","5000"]
    logConfiguration = { logDriver = "awslogs", options = { awslogs-group = aws_cloudwatch_log_group.lg.name, awslogs-region = data.aws_region.current.name, awslogs-stream-prefix = "ecs" } }
    essential = true
  }])
}

resource "aws_ecs_service" "mlflow" {
  name            = "${var.name}-mlflow-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.mlflow.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration { subnets = var.private_subnet_ids security_groups = [var.sg_id] }
  load_balancer { target_group_arn = var.tg_arn container_name = "mlflow" container_port = 5000 }
}
