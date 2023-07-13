module "log_analytics" {
  source = "registry.terraform.io/telekom-mms/log-analytics/azurerm"
  log_analytics_workspace = {
    logmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
}

module "storage" {
  source = "registry.terraform.io/telekom-mms/storage/azurerm"
  storage_account = {
    stmms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
    }
  }
  storage_share = {
    share-mms = {
      storage_account_name = module.storage.storage_account["stmms"].name
      quota                = 5
    }
  }
}

module "container_app" {
  source = "registry.terraform.io/telekom-mms/terraform-azurerm-container-app/azurerm"
  container_app_environment = {
    app = {
      location                   = "westeurope"
      resource_group_name        = "rg-mms-github"
      log_analytics_workspace_id = module.log_analytics.log_analytics_workspace["logmms"].id
    }
  }
  container_app_environment_storage = {
    share-mms = {
      container_app_environment_id = module.container_app.container_app_environment["app"].id
      account_name                 = module.storage.storage_share["share-mms"].storage_account_name
      access_key                   = module.storage.storage_account["stmms"].primary_access_key
      share_name                   = module.storage.storage_share["share-mms"].name
    }
  }
}
