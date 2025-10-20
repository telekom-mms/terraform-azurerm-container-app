/**
* # container_app
*
* This module manages the azurerm container_app resources.
* For more information see https://registry.terraform.io/providers/azurerm/latest/docs > container_app
*
*/

resource "azurerm_container_app_environment" "container_app_environment" {
  for_each = var.container_app_environment

  name                                        = local.container_app_environment[each.key].name == "" ? each.key : local.container_app_environment[each.key].name
  resource_group_name                         = local.container_app_environment[each.key].resource_group_name
  location                                    = local.container_app_environment[each.key].location
  dapr_application_insights_connection_string = local.container_app_environment[each.key].dapr_application_insights_connection_string
  infrastructure_subnet_id                    = local.container_app_environment[each.key].infrastructure_subnet_id
  internal_load_balancer_enabled              = local.container_app_environment[each.key].internal_load_balancer_enabled
  zone_redundancy_enabled                     = local.container_app_environment[each.key].zone_redundancy_enabled
  log_analytics_workspace_id                  = local.container_app_environment[each.key].log_analytics_workspace_id
  tags                                        = local.container_app_environment[each.key].tags
  public_network_access = "Enabled"
  
  dynamic "workload_profile" {
    for_each =  local.container_app_environment[each.key].workload_profile == null ? [] : [0]
    content { 
      name                  = local.container_app_environment[each.key].workload_profile.name
      workload_profile_type = local.container_app_environment[each.key].workload_profile.workload_profile_type
      minimum_count         = local.container_app_environment[each.key].workload_profile.minimum_count
      maximum_count         = local.container_app_environment[each.key].workload_profile.maximum_count
    }
  }
}

resource "azurerm_container_app_environment_storage" "container_app_environment_storage" {
  for_each = var.container_app_environment_storage

  name                         = local.container_app_environment_storage[each.key].name == "" ? each.key : local.container_app_environment_storage[each.key].name
  container_app_environment_id = local.container_app_environment_storage[each.key].container_app_environment_id
  account_name                 = local.container_app_environment_storage[each.key].account_name
  access_key                   = local.container_app_environment_storage[each.key].access_key
  share_name                   = local.container_app_environment_storage[each.key].share_name
  access_mode                  = local.container_app_environment_storage[each.key].access_mode
}
