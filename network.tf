resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.proyecto}-${var.entorno}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.ubicacion
    address_space       = ["10.0.0.0/16"]

    tags = {
        environment = var.entorno
        proyect = var.proyecto
        created_by = "Terraform"
    }
}

resource "azurerm_subnet" "subnetdb" {
  name                 = "subnet-db-${var.proyecto}-${var.entorno}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetapp" {
  name                 = "subnet-app-${var.proyecto}-${var.entorno}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}