output "s3_bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.static_site_bucket.id
}

output "website_endpoint" {
  description = "The S3 static website endpoint."
  value       = aws_s3_bucket.static_site_bucket.website_endpoint
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.static_site_bucket.arn
}
