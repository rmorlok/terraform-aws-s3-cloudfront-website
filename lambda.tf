data "archive_file" "security-headers-zip" {
  type        = "zip"
  source {
    content = <<JAVASCRIPT
'use strict';

// Based on:
// https://aws.amazon.com/blogs/networking-and-content-delivery/adding-http-security-headers-using-lambdaedge-and-amazon-cloudfront/
// https://medium.com/@netscylla/adding-security-headers-to-s3-websites-2002f243aa8f
exports.add_security_headers = (event, context, callback) => {

    // Get contents of response
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    const content_security_policy = ${var.content_security_policy_json},
          additional_headers = ${var.additional_headers};

    // Set new headers
    headers['strict-transport-security'] = [{
        key: 'Strict-Transport-Security',
        value: 'max-age=63072000; includeSubdomains; preload'
    }];
    headers['content-security-policy'] = [{
        key: 'Content-Security-Policy',
        value: Object.keys(content_security_policy).map(k => k + ' ' + content_security_policy[k].join(' ')).join('; ')
    }];

    // Set additional headers
    for (var key in additional_headers) {
	  if (additional_headers.hasOwnProperty(key)) {
		headers[key.toLowerCase()] = [{key: key, value: additional_headers[key]}];
	  }
    }

    // Return modified response
    callback(null, response);
};
JAVASCRIPT
    filename = "exports.js"
  }
  output_path = "${path.module}/out/${var.deployment_name}_lambda_security_headers.zip"
}

resource "aws_lambda_function" "security-headers" {
  filename      = data.archive_file.security-headers-zip.output_path
  function_name = "${var.deployment_name}_security_headers"
  description   = "Managed via Terraform; s3_cloudfront_deployment: ${var.deployment_name}"
  role          = aws_iam_role.iam-for-lambda.arn
  handler       = "exports.add_security_headers"
  source_code_hash = filebase64sha256(
    data.archive_file.security-headers-zip.output_path,
  )
  runtime = "nodejs10.x"
  publish = true
}
