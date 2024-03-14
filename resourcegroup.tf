#Create Resource Group in EAST US for Deployment
resource "azurerm_resource_group" "R1_EUSPRODRG" {
  location = "EASTUS"
  name     = "EUSPRODRG"
}

resource "azurerm_resource_group" "R2_UKSPRODRG" {
  location = "UKSOUTH"
  name     = "UKSPRODRG"
}