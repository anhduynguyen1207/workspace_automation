provider "tfe" {
}
variable "workspace_name" {
  type = string
}
variable "organization" {
  type = string
}
variable "tf_version" {
  default = "1.2.7"
}
data "tfe_workspace" "workspace" {
  name         = var.workspace_name
  organization = var.organization
}
output "workspace_id" {
  value = data.tfe_workspace.workspace.id
}
output "workspace_terraform_version" {
  value = data.tfe_workspace.workspace.terraform_version
}

variable "workspace_name_new" {
  type = string
}
resource "tfe_workspace" "workspace_new" {
  name              = var.workspace_name_new
  organization      = var.organization
  terraform_version = var.tf_version
}
output "workspace_new_id" {
  value = tfe_workspace.workspace_new.id
}

output "workspace_new_terraform_version" {
  value = tfe_workspace.workspace_new.terraform_version
}

resource "tfe_variable" "managed" {
  key          = "variable_name"
  value        = "variable_value"
  category     = "terraform"
  workspace_id = tfe_workspace.workspace_new.id
  description  = "This an example of a regular variable"
}

resource "tfe_variable" "sensitive" {
  key          = "my_variable_sensitive"
  value        = "my_sensitive_value"
  category     = "terraform"
  workspace_id = tfe_workspace.workspace_new.id
  description  = "This an example of an sensitive variable"
  sensitive    = true
}

resource "tfe_variable" "hcl" {
  key          = "my_variable_hcl"
  value        = "[hcl_variable_value]"
  category     = "terraform"
  workspace_id = tfe_workspace.workspace_new.id
  hcl          = true
  description  = "This an example of an hcl variable"
}

