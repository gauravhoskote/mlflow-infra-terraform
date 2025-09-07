variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "sg_id" {
  type = string
}

variable "ecs_instance_profile" {
  type = string
}

variable "batch_service_role" {
  type = string
}

variable "ecr_image" {
  type = string
}

variable "mlflow_url" {
  type = string
}

# NEW: control whether job queues are ENABLED or DISABLED
variable "job_queue_state" {
  type    = string
  default = "ENABLED"
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.job_queue_state)
    error_message = "job_queue_state must be either ENABLED or DISABLED."
  }
}
