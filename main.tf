provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg"{
    name = "rg-${var.proyecto}-${var.entorno}"
    location = var.ubicacion

    tags = {
        environment = var.entorno
        proyect = var.proyecto
        created_by = "Terraform"
    }
}