module "static_site" {
  source = "./modules/s3-static-site"

  s3_bucket_name = var.s3_bucket_name
  aws_region     = var.aws_region
}
