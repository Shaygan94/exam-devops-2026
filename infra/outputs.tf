output "service_url" {
  value       = aws_ecs_express_gateway_service.this.ingress_paths[0].endpoint
  description = "public URL of the ECS Express service"
}

output "service_name" {
  value       = aws_ecs_express_gateway_service.this.service_name
  description = "Name of the ECS Express service"
}

output "service_arn" {
  value       = aws_ecs_express_gateway_service.this.service_arn
  description = "The ARN (Amazon resource name) of the ECS Express service"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.image_bucket.id
  description = "Name of the S3 bucket for images"
}