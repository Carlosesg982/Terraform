provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg"{
    name = "rg-SE_WebApp-dev"
    location = "East US 2"

    tags = {
        environment = "dev"
        proyect = "SE_WebApp"
        created_by = "Terraform"
    }
}