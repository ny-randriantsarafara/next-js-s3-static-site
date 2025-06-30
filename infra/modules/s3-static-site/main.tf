resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Project     = "NextjsStaticSite"
    Environment = "Production"
  }
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
}
