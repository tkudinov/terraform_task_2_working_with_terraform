terraform {
  required_providers {
    ad = {
      source  = "hashicorp/ad"
      version = "0.5.0"
    }
  }
}
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name = var.container_name
  storage_account_name = azurerm_storage_account.example.name
  container_access_type = "blob"
}

resource "null_resource" "upload_archive" {
  provisioner "local-exec" {
    command = "az storage blob upload --account-name ${azurerm_storage_account.example.name} --container-name ${azurerm_storage_container.example.name} --name terraform.zip --file ./terraform.zip --auth-mode login"
  }

  triggers = {
    archive_md5 = filemd5("./terraform.zip")
  }
}
