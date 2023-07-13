output "container_app_environment" {
  description = "Outputs all attributes of resource_type."
  value = {
    for container_app_environment in keys(azurerm_container_app_environment.container_app_environment) :
    container_app_environment => {
      for key, value in azurerm_container_app_environment.container_app_environment[container_app_environment] :
      key => value
    }
  }
}

output "container_app_environment_storage" {
  description = "Outputs all attributes of resource_type."
  value = {
    for container_app_environment_storage in keys(azurerm_container_app_environment_storage.container_app_environment_storage) :
    container_app_environment_storage => {
      for key, value in azurerm_container_app_environment_storage.container_app_environment_storage[container_app_environment_storage] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      container_app_environment = {
        for key in keys(var.container_app_environment) :
        key => local.container_app_environment[key]
      }
      container_app_environment_storage = {
        for key in keys(var.container_app_environment_storage) :
        key => local.container_app_environment_storage[key]
      }
    }
  }
}
