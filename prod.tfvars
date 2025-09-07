project            = "mlflow"
env                = "prod"
region             = "us-east-1"

# RDS
db_password        = "changeMe_UseLongRandom"

# ACM cert in the SAME region as your ALB
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-efgh-ijkl"
