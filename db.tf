resource "azurerm_mssql_server" "sql_server" {
    name = "sqlserver-${var.proyecto}-${var.entorno}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.ubicacion
    version = "12.0"
    administrator_login = "sqladmin"
    administrator_login_password = "Password1234"

    tags = {
        environment = var.entorno
        proyect = var.proyecto
        created_by = "Terraform"
    }
}