variable "name" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "sg_id" { type = string }
variable "instance_class" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "db_name"  { type = string }
variable "multi_az" { type = bool }
