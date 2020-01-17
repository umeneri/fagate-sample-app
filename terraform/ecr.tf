resource "aws_ecr_repository" "frontend_repository" {
  name = "${var.env}-frontend"
}

resource "aws_ecr_repository" "backend_repository" {
  name = "${var.env}-backend"
}
