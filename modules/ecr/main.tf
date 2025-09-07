resource "aws_ecr_repository" "repo" {
  name = "${var.name}-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}
output "repo_url" { value = aws_ecr_repository.repo.repository_url }
