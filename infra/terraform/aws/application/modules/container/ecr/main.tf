resource "aws_ecr_repository" "food-app-ecr" {
  name                 = "${var.project}-ecr-repository-${var.environment}"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
