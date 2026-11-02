variable "aws_region" {
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  type    = string
  default = "wishifai"
}

variable "candidate_number" {
  type        = string
  default     = "13" 
}

variable "image" {
  type=string
  default = "244530008913.dkr.ecr.eu-west-1.amazonaws.com/wishifai-repo-13:latest"

  description = "Full container image URI (registry + repository + tag) that the ECS task will run"

  validation {
    condition     = can(regex("^[0-9]{12}\\.dkr\\.ecr\\.[a-z0-9-]+\\.amazonaws\\.com/[a-z0-9][a-z0-9._/-]*:[A-Za-z0-9._-]+$", var.image))
    error_message = "image must have the format <account>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>."
  }
}

