output "account_endpoint" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}

output "primary_sql_connection_string" {
  value = azurerm_cosmosdb_account.cosmos.primary_sql_connection_string
  sensitive = true
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.container.name
}
