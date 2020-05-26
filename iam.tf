resource "aws_iam_role" "iam-for-lambda" {
  name               = "${var.deployment_name}_lambda"
  description        = "Managed via Terraform; s3_cloudfront_deployment: ${var.deployment_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3-deploy" {
  name        = "${var.deployment_name}_s3_deploy"
  path        = "/"
  description = "Managed via Terraform; s3_cloudfront_deployment: ${var.deployment_name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cloudfront-deploy" {
  name        = "${var.deployment_name}_cloudfront_deploy"
  path        = "/"
  description  = "Managed via Terraform; s3_cloudfront_deployment: ${var.deployment_name}"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "acm:ListCertificates",
            "cloudfront:GetDistribution",
            "cloudfront:GetDistributionConfig",
            "cloudfront:ListDistributions",
            "cloudfront:ListCloudFrontOriginAccessIdentities",
            "cloudfront:GetInvalidation",
            "cloudfront:ListInvalidations",
            "elasticloadbalancing:DescribeLoadBalancers",
            "iam:ListServerCertificates",
            "sns:ListSubscriptionsByTopic",
            "sns:ListTopics",
            "waf:GetWebACL",
            "waf:ListWebACLs"
         ],
         "Resource": "*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "cloudfront:CreateInvalidation"
         ],
         "Resource": "*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:ListAllMyBuckets"
         ],
         "Resource":"arn:aws:s3:::*"
      }
   ]
}
EOF
}

resource "aws_iam_group" "deployers" {
  name = "${var.deployment_name}_deployers"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "wcd-deployers-s3-candidate-webui-deploy" {
  group      = aws_iam_group.deployers.name
  policy_arn = aws_iam_policy.s3-deploy.arn
}

resource "aws_iam_group_policy_attachment" "wcd-deployers-cloudfront-candidate-webui-deploy" {
  group      = aws_iam_group.deployers.name
  policy_arn = aws_iam_policy.cloudfront-deploy.arn
}