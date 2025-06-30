module "static_site" {
  source = "./modules/s3-static-site"

  s3_bucket_name = var.s3_bucket_name
  aws_region     = var.aws_region
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket."
  value       = module.static_site.s3_bucket_name
}