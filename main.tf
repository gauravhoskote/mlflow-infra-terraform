
locals {
  name = "${var.project}-${var.env}"
}

module "vpc" {
  source               = "../../modules/vpc"
  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "s3_artifacts" {
  source      = "../../modules/s3_artifacts"
  bucket_name = "${local.name}-artifacts"
}

module "iam" {
  source         = "../../modules/iam"
  name           = local.name
  s3_bucket_arn  = module.s3_artifacts.bucket_arn
}

module "rds" {
  source             = "../../modules/rds_postgres"
  name               = local.name
  private_subnet_ids = module.vpc.private_subnet_ids
  sg_id              = module.vpc.db_sg_id
  instance_class     = var.db_instance_class
  username           = var.db_username
  password           = var.db_password
  db_name            = var.db_name
  multi_az           = var.rds_multi_az
}

module "ecr" {
  source = "../../modules/ecr"
  name   = local.name
}

module "alb" {
  source            = "../../modules/alb"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_id             = module.vpc.alb_sg_id
  # (HTTPS removed)  no acm_arn here
}


module "ecs_mlflow" {
  source               = "../../modules/ecs_mlflow"
  name                 = local.name
  private_subnet_ids   = module.vpc.private_subnet_ids
  sg_id                = module.vpc.ecs_sg_id
  exec_role_arn        = module.iam.ecs_task_execution_role_arn
  artifacts_bucket     = module.s3_artifacts.bucket_name
  artifacts_bucket_arn = module.s3_artifacts.bucket_arn
  db_host              = module.rds.endpoint
  db_port              = module.rds.port
  db_user              = var.db_username
  db_pass              = var.db_password
  db_name              = var.db_name
  tg_arn               = module.alb.target_group_arn
  mlflow_image         = "ghcr.io/mlflow/mlflow:latest"
}

module "batch" {
  source               = "../../modules/batch"
  name                 = local.name
  region               = var.region
  private_subnet_ids   = module.vpc.private_subnet_ids
  sg_id                = module.vpc.batch_sg_id
  ecs_instance_profile = module.iam.ecs_instance_profile_arn
  batch_service_role   = module.iam.batch_service_role_arn
  ecr_image            = module.ecr.repo_url
  mlflow_url           = "https://${module.alb.alb_dns}"
}
