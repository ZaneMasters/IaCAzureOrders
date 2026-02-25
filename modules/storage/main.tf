resource "azurerm_storage_account" "storage" {
  name                     = replace("${var.prefix}storage", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "orders_to_process" {
  name                 = "orders-to-process"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_queue" "orders_processed" {
  name                 = "orders-processed"
  storage_account_name = azurerm_storage_account.storage.name
}
