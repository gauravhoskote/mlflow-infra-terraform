variable "name" { type = string }
variable "region" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "sg_id" { type = string }
variable "ecs_instance_profile" { type = string }
variable "batch_service_role"   { type = string }
variable "ecr_image" { type = string }
variable "mlflow_url" { type = string }
