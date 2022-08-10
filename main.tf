module "iam" {
  source = ".\\iam\\"
  providers = {
    aws = aws.us
   }

  #Roles input
  Lambda_access = {
    name = var.Lambda_access.name
    jsonfile_name = var.Lambda_access.jsonfile_name
  }
}

module "Infrastructure" {
  source = ".\\Infrastructure\\"
  providers = {
    aws = aws.us
   }

  #Infrastructure inputs
  #Lambda inputs
  function_name = var.function_name
  lambda_role = module.iam.lambda_role_arn

  #API gateway inputs
  #API Names
  API_name = var.API_name
  #Creation of the resources to be associated the api
  ApiResourceName = var.ApiResourceName
  #Creation of the api methods
  http_method = var.http_method
  authorization = var.authorization
  resourceName = var.resourceName
  lambda_uri = var.lambda_uri
  maptemplate = var.maptemplate

  depends_on = [
    module.iam
  ]
}