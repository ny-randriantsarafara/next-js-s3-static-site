variable "aws_region" {
  description = "The AWS region to deploy resources to."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for the static site."
  type        = string
}
