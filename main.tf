locals {
  prefix = "${var.project_name}-${var.environment}"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = var.location
}

module "storage" {
  source              = "./modules/storage"
  prefix              = local.prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "cosmosdb" {
  source              = "./modules/cosmosdb"
  prefix              = local.prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "function_app" {
  source                     = "./modules/function_app"
  prefix                     = local.prefix
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = module.storage.account_name
  storage_account_access_key = module.storage.primary_access_key
  storage_connection_string  = module.storage.primary_connection_string
  cosmos_connection_string   = module.cosmosdb.primary_sql_connection_string
  cosmos_db_name             = module.cosmosdb.database_name
  cosmos_container_name      = module.cosmosdb.container_name

  depends_on = [
    module.storage,
    module.cosmosdb
  ]
}