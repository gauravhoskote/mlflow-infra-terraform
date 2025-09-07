
variable "project" { type = string }
variable "env"     { type = string }
variable "region"  { type = string }

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidrs"  { default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnet_cidrs" {  default = ["10.0.11.0/24","10.0.12.0/24"] }

variable "db_username"       {  default = "mlflow" }
variable "db_password"       {  sensitive = true }
variable "db_instance_class" {  default = "db.t3.medium" }
variable "db_name"           {  default = "mlflow" }
variable "rds_multi_az"      {    default = false }

