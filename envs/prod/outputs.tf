output "mlflow_url"           { value = "https://${module.alb.alb_dns}" }
output "ecr_repo_url"         { value = module.ecr.repo_url }
output "train_queue_name"     { value = module.batch.train_queue_name }
output "eval_queue_name"      { value = module.batch.eval_queue_name }
output "job_definition_name"  { value = module.batch.job_definition_name }
