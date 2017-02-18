variable "aws_region" { }
variable "apex_environment" {}

data "aws_caller_identity" "current" { }

provider "aws" {
  region      = "${var.aws_region}"
}

resource "aws_api_gateway_rest_api" "APIGateway" {
  name        = "APIGateway"
  description = "Entry point API for all requests"
}

resource "aws_api_gateway_deployment" "APIDeployment" {
  rest_api_id = "${aws_api_gateway_rest_api.APIGateway.id}"
  stage_name  = "${var.apex_environment}"

  depends_on = ["aws_api_gateway_integration.CarIntegration"]

  # forces to 'create' a new deployment each run
  # see this comment and/or thread:
  # https://github.com/hashicorp/terraform/issues/6613#issuecomment-289799360
  stage_description = "${timestamp()}"
}

output "API Invoke URL" {
  value       = "https://${aws_api_gateway_rest_api.APIGateway.id}.execute-api.${var.aws_region}.amazonaws.com/${var.apex_environment}"
}
