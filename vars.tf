#Iam vars
variable "Lambda_access" {
    type = map(any)
    description = "Lambda assume role to access the ECS in another account"
    default = {
      name = ""
      jsonfile_name = ""
    }
}

#Infrastructure vars
#Lambda Vars
variable "function_name" {
    type = list(string)
    description = "name of the lambda function"
}

#API Gateway vars
#Api vars
variable "API_name" {
    type = string
    description = "Api gateway name"
}
#Resource vars
variable "ApiResourceName" {
    type = list(string)
    description = "Resource for the api gateway"
}
#Method vars
variable "http_method" {
    type = list(string)
    description = "Method for the api gateway"
}

variable "authorization" {
    type = list(string)
    description = "Type of method authorization for the api gateway"
}

variable "resourceName" {
    type = list(string)
    description = "Name of the API resource that will be used to create the method"
}

variable "lambda_uri" {
    type = list(string)
    description = "The arn of lambda function to be used on the creation of integration method"
}

variable "maptemplate" {
    type = list(string)
    description = "Specification of the mapping template file to be used on the method to transport the variables from the api request to the lambda function"
}