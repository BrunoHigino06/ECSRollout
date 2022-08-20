#ECS Rollout Lambdas
resource "aws_lambda_function" "MainLambda" {
  count = length(var.function_name)
  filename      = "./lambdacode/${var.function_name[count.index]}.zip"
  function_name = var.function_name[count.index]
  role          = var.lambda_role
  source_code_hash = filebase64sha256("./lambdacode/${var.function_name[count.index]}.zip")
  handler = "${var.function_name[count.index]}.lambda_handler"
  timeout = "60"

  runtime = "python3.8"


  tags = {
    "name" = var.function_name[count.index]
  }
}

#Api gateway to acess the lambdas
#API
resource "aws_api_gateway_rest_api" "MainAPiGateway" {
  name        = var.API_name
  description = "API to trigger the lambda functions"

  depends_on = [
    aws_lambda_function.MainLambda
  ]
}

#API gateway Lambda permission 
resource "aws_lambda_permission" "lambda_permission" {
  count = length(var.function_name)
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name[count.index]
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.MainAPiGateway.execution_arn}/*/*/${var.ApiResourceName[count.index]}"

  depends_on = [
    aws_lambda_function.MainLambda
  ]
}

#API Resource
resource "aws_api_gateway_resource" "MainAPIResource" {
  count = length(var.ApiResourceName)
  rest_api_id = aws_api_gateway_rest_api.MainAPiGateway.id
  parent_id   = aws_api_gateway_rest_api.MainAPiGateway.root_resource_id
  path_part   = var.ApiResourceName[count.index]

  depends_on = [
    aws_api_gateway_rest_api.MainAPiGateway
  ]
}

#API Methods
resource "aws_api_gateway_method" "MainAPIMethod" {
  count = length(var.http_method)
  rest_api_id   = aws_api_gateway_rest_api.MainAPiGateway.id
  resource_id   = data.aws_api_gateway_resource.ResourceID[count.index].id
  http_method   = var.http_method[count.index]
  authorization = var.authorization[count.index]

  depends_on = [
    data.aws_api_gateway_resource.ResourceID
  ]
}

#API integration
resource "aws_api_gateway_integration" "MainIntegration" {
  count = length(var.http_method)
  rest_api_id             = aws_api_gateway_rest_api.MainAPiGateway.id
  resource_id             = data.aws_api_gateway_resource.ResourceID[count.index].id
  http_method             = var.http_method[count.index]
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = data.aws_lambda_function.lambda_uri[count.index].invoke_arn
  request_templates = {
    "application/json" = file("./Infrastructure/maptemplate/map.template")
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"

  depends_on = [
    data.aws_lambda_function.lambda_uri,
    aws_api_gateway_rest_api.MainAPiGateway,
    aws_api_gateway_method.MainAPIMethod
  ]
}

#Method response
#200
resource "aws_api_gateway_method_response" "response_200" {
  count = length(var.http_method)
  rest_api_id = aws_api_gateway_rest_api.MainAPiGateway.id
  resource_id = data.aws_api_gateway_resource.ResourceID[count.index].id
  http_method = aws_api_gateway_integration.MainIntegration[count.index].http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_rest_api.MainAPiGateway
  ]
}

#integration response
#200
resource "aws_api_gateway_integration_response" "IntegrationResponse_200" {
  count = length(var.http_method)
  rest_api_id = aws_api_gateway_rest_api.MainAPiGateway.id
  resource_id = data.aws_api_gateway_resource.ResourceID[count.index].id
  http_method = var.http_method[count.index]
  status_code = aws_api_gateway_method_response.response_200[count.index].status_code

  depends_on = [
    aws_api_gateway_rest_api.MainAPiGateway
  ]  
}