data "aws_api_gateway_resource" "ResourceID" {
    count = length(var.http_method)
    rest_api_id = aws_api_gateway_rest_api.MainAPiGateway.id
    path        = "/${var.resourceName[count.index]}"
    depends_on = [
      aws_api_gateway_rest_api.MainAPiGateway,
      aws_api_gateway_resource.MainAPIResource
    ]
}

data "aws_lambda_function" "lambda_uri" {
    count = length(var.lambda_uri)
    function_name = var.lambda_uri[count.index]

    depends_on = [
      aws_lambda_function.MainLambda
    ]
}