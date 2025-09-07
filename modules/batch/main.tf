resource "aws_batch_compute_environment" "train" {
  name = "${var.name}-train-ce"
  type = "MANAGED"
  compute_resources {
    type = "EC2"
    instance_type = ["g5.xlarge","p3.2xlarge"]
    min_vcpus = 0
    max_vcpus = 256
    desired_vcpus = 0
    subnets = var.private_subnet_ids
    security_group_ids = [var.sg_id]
    instance_role = var.ecs_instance_profile
  }
  service_role = var.batch_service_role
}

resource "aws_batch_compute_environment" "eval" {
  name = "${var.name}-eval-ce"
  type = "MANAGED"
  compute_resources {
    type = "EC2"
    instance_type = ["c6i.large","c6i.xlarge"]
    min_vcpus = 0
    max_vcpus = 256
    desired_vcpus = 0
    subnets = var.private_subnet_ids
    security_group_ids = [var.sg_id]
    instance_role = var.ecs_instance_profile
  }
  service_role = var.batch_service_role
}

resource "aws_batch_job_queue" "train" {
  name     = "${var.name}-train-queue"
  state    = "ENABLED"
  priority = 10

  # Highest priority CE first
  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.train.arn
  }
}

resource "aws_batch_job_queue" "eval" {
  name     = "${var.name}-eval-queue"
  state    = "ENABLED"
  priority = 10

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.eval.arn
  }
}


resource "aws_batch_job_definition" "mlproj" {
  name = "${var.name}-jobdef"
  type = "container"
  platform_capabilities = ["EC2"]
  container_properties = jsonencode({
    image = var.ecr_image
    vcpus = 4
    memory = 16000
    command = []
    environment = [
      {"name":"MLFLOW_TRACKING_URI","value": var.mlflow_url},
      {"name":"AWS_DEFAULT_REGION","value": var.region}
    ]
    logConfiguration = { logDriver = "awslogs", options = {"awslogs-group": "/aws/batch/job", "awslogs-region": var.region, "awslogs-stream-prefix": "batch"} }
  })
}

output "train_queue_name"   { value = aws_batch_job_queue.train.name }
output "eval_queue_name"    { value = aws_batch_job_queue.eval.name }
output "job_definition_name"{ value = aws_batch_job_definition.mlproj.name }
