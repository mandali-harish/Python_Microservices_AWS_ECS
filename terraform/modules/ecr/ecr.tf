resource "aws_ecr_repository" "app1" {
  name                 = "${var.project_name}-app1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "app2" {
  name                 = "${var.project_name}-app2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "app1_ecr_url" {
  value = aws_ecr_repository.app1.repository_url
}

output "app2_ecr_url" {
  value = aws_ecr_repository.app2.repository_url
}