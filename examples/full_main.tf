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

module "network" {
  source = "registry.terraform.io/telekom-mms/network/azurerm"
  virtual_network = {
    vn-app-mms = {
      location            = "westeurope"
      resource_group_name = "rg-mms-github"
      address_space       = ["173.0.0.0/28"]
    }
  }
  subnet = {
    snet-app-mms = {
      resource_group_name  = module.network.virtual_network["vn-app-mms"].resource_group_name
      address_prefixes     = ["173.0.0.0/29"]
      virtual_network_name = module.network.virtual_network["vn-app-mms"].name
    }
  }
}

module "container_app" {
  source = "registry.terraform.io/telekom-mms/terraform-azurerm-container-app/azurerm"
  container_app_environment = {
    app = {
      location                   = "westeurope"
      resource_group_name        = "rg-mms-github"
      infrastructure_subnet_id   = module.network.subnet["snet-app-mms"].id
      log_analytics_workspace_id = module.log_analytics.log_analytics_workspace["logmms"].id
      tags = {
        project     = "mms-github"
        environment = terraform.workspace
        managed-by  = "terraform"
      }
    }
  }
  container_app_environment_storage = {
    share-mms = {
      container_app_environment_id = module.container_app.container_app_environment["app"].id
      account_name                 = module.storage.storage_share["share-mms"].storage_account_name
      access_key                   = module.storage.storage_account["stmms"].primary_access_key
      share_name                   = module.storage.storage_share["share-mms"].name
      access_mode                  = "ReadWrite"
    }
  }
}
