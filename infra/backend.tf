terraform {
  backend "s3" {
    bucket         = "nextjs-s3-static-site-terraform"
    key            = "state.tfstate"
    region         = "eu-west-1"
    use_lockfile   = true
    encrypt        = true
  }
}
