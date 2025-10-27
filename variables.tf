variable "container_app_environment" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}
variable "container_app_environment_storage" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}


locals {
  default = {
    // resource definition
    container_app_environment = {
      name                                        = ""
      id                                          = null
      dapr_application_insights_connection_string = null
      infrastructure_subnet_id                    = null
#      internal_load_balancer_enabled              = null
      zone_redundancy_enabled                     = null
      log_analytics_workspace_id                  = null
      tags                                        = {}
#      workload_profile = {
#        name       = ""
#        workload_profile_type  = null
#        minimum_count = null
#        maximum_count = null
#      }
    }
    container_app_environment_storage = {
      name        = ""
      access_mode = "ReadOnly" // defined default
    }
  }

  // compare and merge custom and default values
  // deep merge of all custom and default values
  container_app_environment = {
    for container_app_environment in keys(var.container_app_environment) :
    container_app_environment => merge(local.default.container_app_environment, var.container_app_environment[container_app_environment])
  }
  container_app_environment_storage = {
    for container_app_environment_storage in keys(var.container_app_environment_storage) :
    container_app_environment_storage => merge(local.default.container_app_environment_storage, var.container_app_environment_storage[container_app_environment_storage])
  }
}
