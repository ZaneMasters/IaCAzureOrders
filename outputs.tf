output "function_app_name" {
  value = module.function_app.function_app_name
}

output "function_app_url" {
  value = "https://${module.function_app.function_app_default_hostname}"
}

output "cosmos_endpoint" {
  value = module.cosmosdb.account_endpoint
}