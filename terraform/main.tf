terraform {
  required_providers {
    ad = {
      source  = "hashicorp/ad"
      version = "0.5.0"
    }
  }
}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name = "test-container"
  storage_account_name = azurerm_storage_account.example.name
  container_access_type = "blob"
}

resource "null_resource" "upload_archive" {
  provisioner "local-exec" {
    command = "az storage blob upload --account-name ${azurerm_storage_account.example.name} --container-name ${azurerm_storage_container.example.name} --name terraform.zip --file ./terraform.zip --auth-mode login"
  }

  triggers = {
    archive_md5 = filemd5("./app_bundle.zip")
  }
}
