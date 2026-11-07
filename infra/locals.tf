locals {
  aws_account_id = "244530008913"

  image_uri = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.project_name}-repo-${var.candidate_number}:${var.image_tag}"
}