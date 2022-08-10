variable "Lambda_access" {
    type = map(any)
    description = "Lambda assume role to access the ECS in another account"
    default = {
      name = ""
      jsonfile_name = ""
    }
}