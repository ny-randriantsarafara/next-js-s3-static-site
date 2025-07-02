resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Project     = "NextjsStaticSite"
    Environment = "Production"
  }
}

# IMPORTANT: This block disables public access blocking for the S3 bucket.
# This is necessary for directly serving a public static website from S3.
# If you intend to serve a private site or use CloudFront with OAC,
# you should re-enable these settings and configure CloudFront accordingly.
resource "aws_s3_bucket_public_access_block" "static_site_public_access_block" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_site_website_configuration" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${aws_s3_bucket.static_site_bucket.arn}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.static_site_public_access_block]
}
