resource "aws_ecr_repository" "web" {
  name = "${var.name}-web"

  tags = merge(var.common_tags, { Name = format("%s-ecr-web", var.name) })
}

resource "aws_ecr_lifecycle_policy" "web" {
  repository = aws_ecr_repository.web.name

  policy = file("${path.module}/templates/ecr_lifecycle_policy.json")
}

resource "aws_ecr_repository" "nginx" {
  name = "${var.name}-nginx"

  tags = merge(var.common_tags, { Name = format("%s-ecr-nginx", var.name) })
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name

  policy = file("${path.module}/templates/ecr_lifecycle_policy.json")
}
