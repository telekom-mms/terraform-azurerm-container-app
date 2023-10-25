<!-- BEGIN_TF_DOCS -->
# container_app

This module manages the azurerm container_app resources.
For more information see https://registry.terraform.io/providers/azurerm/latest/docs > container_app

_<-- This file is autogenerated, please do not change. -->_

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.3 |
| azurerm | >=3.57.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >=3.57.0 |

## Resources

| Name | Type |
|------|------|
| azurerm_container_app_environment.container_app_environment | resource |
| azurerm_container_app_environment_storage.container_app_environment_storage | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container_app_environment | Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs). | `any` | `{}` | no |
| container_app_environment_storage | Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs). | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| container_app_environment | Outputs all attributes of resource_type. |
| container_app_environment_storage | Outputs all attributes of resource_type. |
| variables | Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module |

## Examples

Minimal configuration to install the desired resources with the module

```hcl
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
```

Advanced configuration to install the desired resources with the module

```hcl
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
```
<!-- END_TF_DOCS -->