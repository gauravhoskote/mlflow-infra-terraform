
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier              = "${var.name}-rds"
  engine                  = "postgres"
  engine_version          = "15.4"
  instance_class          = var.instance_class
  allocated_storage       = 50

  db_name   = var.db_name
  username  = var.username
  password  = var.password

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.sg_id]

  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = var.multi_az
}

output "endpoint" { value = aws_db_instance.this.address }
output "port"     { value = aws_db_instance.this.port }
