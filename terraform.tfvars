#Iam inputs
Lambda_access = {
    name = "Lambda_access"
    jsonfile_name = "Lambda_access.json"
}

#Infrastructure inputs
#Lambda inputs
function_name = ["ListClusters", "ListServices", "DesiredCountIn", "DesiredCountOut"]

#API gateway inputs
#API Names
API_name = "ECSRollout"

#Creation of the resources to be associated the api
ApiResourceName = ["ListClusters", "ListServices", "DesiredCountIn", "DesiredCountOut"]

#Creation of the api methods
http_method = ["GET", "GET", "GET", "GET"]
resourceName = ["ListClusters", "ListServices", "DesiredCountIn", "DesiredCountOut"]
lambda_uri = ["ListClusters", "ListServices", "DesiredCountIn", "DesiredCountOut"]
authorization = ["NONE", "NONE", "NONE", "NONE"]
maptemplate = ["ListClusters", "ListServices", "DesiredCountIn", "DesiredCountOut"]