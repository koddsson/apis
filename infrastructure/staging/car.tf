variable "apex_function_car" { }

resource "aws_api_gateway_resource" "CarResource" {
  rest_api_id = "${aws_api_gateway_rest_api.APIGateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.APIGateway.root_resource_id}"
  path_part   = "car"
}

resource "aws_api_gateway_method" "CarMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.APIGateway.id}"
  resource_id   = "${aws_api_gateway_resource.CarResource.id}"
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.plate" = true
  }
}

resource "aws_api_gateway_integration" "CarIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.APIGateway.id}"
  resource_id             = "${aws_api_gateway_resource.CarResource.id}"
  http_method             = "${aws_api_gateway_method.CarMethod.http_method}"
  type                    = "AWS"
  integration_http_method = "POST" # Must be POST for lambda integration
  credentials             = "${aws_iam_role.gateway_invoke_lambda_staging.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.apex_function_car}/invocations"

  request_templates {
    "application/json" = <<EOF
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
}
}
EOF
  }
}

resource "aws_lambda_permission" "APIGateway_CarEndpoint_Auth" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.apex_function_car}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.APIGateway.id}/*/${aws_api_gateway_method.CarMethod.http_method}/resourcepath/subresourcepath"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.APIGateway.id}"
  resource_id = "${aws_api_gateway_resource.CarResource.id}"
  http_method = "${aws_api_gateway_method.CarMethod.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "CarIntegrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.APIGateway.id}"
  resource_id = "${aws_api_gateway_resource.CarResource.id}"
  http_method = "${aws_api_gateway_method.CarMethod.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}
