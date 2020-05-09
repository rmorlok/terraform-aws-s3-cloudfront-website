# Terraform Module to Security Host Website on AWS S3/CloudFront

Terraform module to host a website on S3 with a CloudFront frontend, leveraging Lambda@Edge for the content security
policy (CSP) and an Amazon-issued SSL certificate.

# Example

```hcl-terraform
module "example" {
  source = "github.com/rmorlok/terraform-aws-s3-cloudfront-website"

  deployment_name = "foo"
  aws_region = "us-east-1"
  s3_bucket_name = "example-bucket-name"
  domain_names = ["foo.example.com"]
  acm_certificate_domain = "*.example.com"
  content_security_policy_json = <<JSON
{
  "default-src": [
      "'none'"
  ],
  "frame-src": [
      "data:",
      "*"
  ],
  "img-src": [
      "'self'",
      "data:",
      "blob:",
      "filesystem:",
      "*"
  ],
  "media-src": [
      "'self'",
      "data:",
      "blob:",
      "filesystem:",
      "*"
  ],
  "script-src": [
      "'self'",
      "'unsafe-inline'",
      "https://code.jquery.com"
  ],
  "style-src": [
      "'self'",
      "'unsafe-inline'",
      "data:",
      "*"
  ],
  "object-src": [
      "'none'"
  ],
  "font-src": [
      "'self'",
      "data:",
      "*"
  ],
  "connect-src": [
      "'self'",
  ]
}
JSON
}
```