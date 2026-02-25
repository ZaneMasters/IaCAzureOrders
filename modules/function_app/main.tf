resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.prefix}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "${var.prefix}-func"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME        = "python"
    AzureWebJobsStorage             = var.storage_connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY  = azurerm_application_insights.appinsights.instrumentation_key
    COSMOS_CONNECTION_STRING        = var.cosmos_connection_string
    COSMOS_DATABASE_NAME            = var.cosmos_db_name
    COSMOS_CONTAINER_NAME           = var.cosmos_container_name
  }
}
