variable "aws_region" { }
variable "apex_environment" {}

# TODO: 
#  - Encrypt '*.tfstate*' files(?)

data "aws_caller_identity" "current" { }

data "aws_acm_certificate" "koddsson" {
  provider = "aws.use1"
  domain   = "staging.koddsson.co.uk"
  statuses = ["ISSUED"]
}

provider "aws" {
   # The "default" instance of the provider
  region = "${var.aws_region}"
}

provider "aws" {
  # us-east-1 instance, this is needed for ACM certsA
  # see: https://github.com/hashicorp/terraform/issues/10957#issuecomment-269653276
  region = "us-east-1"
  alias = "use1"
}

resource "aws_api_gateway_rest_api" "APIGateway" {
  name        = "apis.is (staging)"
  description = "Entry point API for all requests"
}

resource "aws_api_gateway_deployment" "APIDeployment" {
  rest_api_id = "${aws_api_gateway_rest_api.APIGateway.id}"
  stage_name  = "${var.apex_environment}"

  # TODO: Either loop somehow through integrations here or document this nuance
  depends_on = ["aws_api_gateway_integration.CarIntegration"]
}

resource "aws_api_gateway_domain_name" "koddsson" {
  domain_name = "staging.koddsson.co.uk"

  certificate_arn = "${data.aws_acm_certificate.koddsson.arn}"
}

data "aws_route53_zone" "koddsson" {
  name         = "koddsson.co.uk."
}

resource "aws_route53_record" "koddsson" {
  zone_id = "${data.aws_route53_zone.koddsson.id}"

  name = "${aws_api_gateway_domain_name.koddsson.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.koddsson.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.koddsson.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_api_gateway_base_path_mapping" "mapURLtoAPI" {
  api_id      = "${aws_api_gateway_rest_api.APIGateway.id}"
  stage_name  = "${aws_api_gateway_deployment.APIDeployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.koddsson.domain_name}"
}

output "API Invoke URL" {
  value       = "https://${aws_api_gateway_rest_api.APIGateway.id}.execute-api.${var.aws_region}.amazonaws.com/${var.apex_environment}"
}
