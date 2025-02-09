data "tfe_team" "classmates" {
  name         = "classmates"
  organization = var.organization
}

data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = var.organization
}

resource "tfe_team_access" "classmates-all" {
  for_each     = data.tfe_workspace_ids.all.ids
  access       = "read"
  team_id      = data.tfe_team.classmates.id
  workspace_id = each.value
}