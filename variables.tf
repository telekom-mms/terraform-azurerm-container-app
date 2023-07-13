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
    container_app_environment = {
      name                           = ""
      infrastructure_subnet_id       = null
      internal_load_balancer_enabled = null
      tags                           = {}
    }
    container_app_environment_storage = {
      name        = ""
      access_mode = "ReadOnly"
    }
  }

  /**
    compare and merge custom and default values
  */
  /**
    deep merge of all custom and default values
  */
  container_app_environment = {
    for container_app_environment in keys(var.container_app_environment) :
    container_app_environment => merge(local.default.container_app_environment, var.container_app_environment[container_app_environment])
  }
  container_app_environment_storage = {
    for container_app_environment_storage in keys(var.container_app_environment_storage) :
    container_app_environment_storage => merge(local.default.container_app_environment_storage, var.container_app_environment_storage[container_app_environment_storage])
  }
}
