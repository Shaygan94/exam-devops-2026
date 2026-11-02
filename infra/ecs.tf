resource "aws_s3_bucket" "image_bucket" {
  bucket = "${var.project_name}-images-${var.candidate_number}"
}

resource "aws_ecs_express_gateway_service" "this" {
  service_name = "${var.project_name}-service-${var.candidate_number}"
  cpu          = "256"
  memory       = "512"

  execution_role_arn      = "arn:aws:iam::244530008913:role/ecsTaskExecutionRole"
  infrastructure_role_arn = "arn:aws:iam::244530008913:role/service-role/ecsInfrastructureRoleForExpressServices"
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  primary_container {
    image = var.image

    environment {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.image_bucket.id
    }
  }
}