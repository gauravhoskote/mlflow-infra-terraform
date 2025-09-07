variable "project" { type = string }
variable "env"     { type = string }
variable "region"  { type = string }
variable "vpc_cidr" { type = string default = "10.0.0.0/16" }
variable "public_subnet_cidrs"  { type = list(string) default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string) default = ["10.0.11.0/24","10.0.12.0/24"] }
variable "db_username" { type = string default = "mlflow" }
variable "db_password" { type = string sensitive = true }
variable "db_instance_class" { type = string default = "db.t3.medium" }
variable "db_name" { type = string default = "mlflow" }
variable "rds_multi_az" { type = bool default = false }
variable "acm_certificate_arn" { type = string }
