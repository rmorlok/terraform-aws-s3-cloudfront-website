variable "deployment_name" {
  type = string
  description = "A name for this deployment. Used in descriptions."
}

variable "aws_region" {
  type = string
  description = "AWS Region for this deployment"
}

variable "s3_bucket_name" {
  type = string
  description = "The name for the bucket that will be created for this distribution"
}

variable "index_document" {
  type = string
  default = "index.html"
  description = "The index document for the SPA, used in cloudfront and s3"
}

variable "domain_names" {
  type = list(string)
  description = "The domain names to be used with this distribtuion; DNS will NOT be automatically mapped."
}

variable "acm_certificate_domain" {
  type = string
  description = "The domain used for the ACM certificate; data only; certificate must already exist"
}

variable "content_security_policy_json" {
  type = string
  description = "The JSON object to use for Lambda for the content security policy"
}

variable "additional_headers" {
  type = string
  description = "Additional headers to apply via the lambda function"
  default = <<JSON
{
  "X-Content-Type-Options": "nosniff",
  "X-Frame-Options": "DENY",
  "X-XSS-Protection": "1; mode=block",
  "Referrer-Policy": "same-origin"
}
JSON
}