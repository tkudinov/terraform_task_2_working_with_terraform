output "storage_id" {
  value = azurerm_storage_container.example.id
}

output "blob_url" {
  value = "https://${azurerm_storage_account.example.name}.blob.core.windows.net/${azurerm_storage_container.example.name}/terraform.zip"

}