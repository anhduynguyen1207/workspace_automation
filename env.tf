variable "apps" {
  description = "Map of applications"
  type        = map(any)
  default = {
    appA = {
      terraform_version = "1.2.7"
    },
    appB = {
      terraform_version = "1.2.8"
    }
  }
}
variable "environments" {
  type    = list(any)
  default = ["sandbox", "development", "production"]
}
locals {
  app_env = flatten([for app_key, app in var.apps : [
    for environment in var.environments : {
      app               = app_key
      environment       = environment
      terraform_version = app.terraform_version
    }
    ]
  ])
}
resource "tfe_workspace" "managed" {
  for_each          = { for env in local.app_env : "${env.app}-${env.environment}" => env }
  name              = each.key
  organization      = var.organization
  terraform_version = each.value.terraform_version
}