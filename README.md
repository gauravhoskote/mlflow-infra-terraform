# mlflow-infra-terraform
A repository to spin up ML Flow setup for Pytorch experiments.


# infra-mlflow-aws
Terraform to deploy MLflow on AWS: S3 + RDS + ECS Fargate (behind HTTPS ALB) + AWS Batch (GPU/CPU) + ECR + IAM.

## Usage
```
cd envs/prod
terraform init
terraform apply
```
Capture outputs: mlflow_url, ecr_repo_url, train_queue_name, eval_queue_name, job_definition_name.
