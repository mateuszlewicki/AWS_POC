provider "aws" {
  #version = "~> 3.0"
  region  = "us-east-1"
}
resource "aws_s3_bucket" "mybucket" {
  bucket = "mlewicki-mybucket-atos.net"
  acl    = "private"

  tags = {
    Name        = "mlewicki-mybucket-atos.net"
  }
}