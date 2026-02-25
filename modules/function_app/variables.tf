variable "prefix" {
  description = "Project and environment prefix"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account for the function app"
  type        = string
}

variable "storage_account_access_key" {
  description = "Primary access key of the storage account"
  type        = string
  sensitive   = true
}

variable "storage_connection_string" {
  description = "Connection string for the storage account"
  type        = string
  sensitive   = true
}

variable "cosmos_connection_string" {
  description = "Connection string for Cosmos DB"
  type        = string
  sensitive   = true
}

variable "cosmos_db_name" {
  description = "Name of the Cosmos DB database"
  type        = string
}

variable "cosmos_container_name" {
  description = "Name of the Cosmos DB container"
  type        = string
}
