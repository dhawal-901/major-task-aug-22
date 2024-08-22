locals {
  config = {
    test = {
      bucket_name    = "app.test2.dhawal.in.net"
      aws_source_arn = "arn:aws:cloudfront::905418378622:distribution/E3A5NO9VOAN05H"
    }
  }

  Environment = local.config.test
}
