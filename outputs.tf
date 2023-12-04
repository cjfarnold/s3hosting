output "hostedurl" {
    value = "http://${aws_s3_bucket.cloudprogramming.bucket}.s3-website.ap-south-1.amazonaws.com"
  
}