terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }

  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "cloudprogramming" {
    bucket = "cloudprogramming211023"
    tags = {
        Name = "cloudprogramming" 
    }
  
}

resource "aws_s3_bucket_website_configuration" "cloudprogramming" {
    bucket = aws_s3_bucket.cloudprogramming.id
    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }
}

resource "aws_s3_bucket_versioning" "cloudprogramming" {
    bucket = aws_s3_bucket.cloudprogramming.id
    versioning_configuration {
        status = "Enabled"
    }
  
}

resource "aws_s3_bucket_ownership_controls" "cloudprogramming" {
    bucket = aws_s3_bucket.cloudprogramming.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "cloudprogramming" {
    bucket = aws_s3_bucket.cloudprogramming.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls =  false
    restrict_public_buckets = false
  
}

resource "aws_s3_bucket_acl" "cloudprogramming" {
    depends_on = [ aws_s3_bucket_ownership_controls.cloudprogramming,
    aws_s3_bucket_public_access_block.cloudprogramming, ]
    bucket = aws_s3_bucket.cloudprogramming.id
    acl = "public-read"
  
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.cloudprogramming.id

  policy = <<POLICY
{
  "Id": "Policy",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudprogramming.bucket}/*",
      "Principal": {
        "AWS": [
          "*"
        ]
      }
    }
  ]
}
POLICY
}