resource "azurerm_function_app" "function_app" {
  name                      = "functio-${var.proyecto}-${var.entorno}"
  location                  = var.ubicacion
  resource_group_name       = azurerm_resource_group.rg.name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  storage_account_name      = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_connection_string
  version                   = "~3"
  os_type                      = "linux"


  app_settings ={
    AzureWebJobsStorage = azurerm_storage_account.storage_account.primary_connection_string
    AzureWebJobsdDashboard = azurerm_storage_account.storage_account.primary_connection_string
    WEBSITE_VNET_ROUTE_ALL = "1"
    QueueStorageConnectionString = azurerm_storage_account.storage_account.primary_connection_string
    QueueName = azurerm_storage_queue.storage_queue.name
    DOCKER_REGISTRY_SERVER_URL = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }

  site_config {
    linux_fx_version = "DOKER|mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart"
    always_on = true
    vnet_route_all_enabled = true

    ip_restriction {
        name = "default-deny"
        ip_address = "0.0.0.0/0"
        action = "Deny"
        priority = 200
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [
    azurerm_app_service_plan.app_service_plan,
    azurerm_subnet.subnetfuntion,
    azurerm_container_registry.acr
  ]

}


resource "azurerm_private_endpoint" "function_private_endpoint" {
  name                = "function-private-endpoint-${var.proyecto}-${var.entorno}"
  location            = var.ubicacion
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnetfuntion.id

  private_service_connection {
    name                           = "function-private-ec-${var.proyecto}-${var.entorno}"
    private_connection_resource_id = azurerm_function_app.function_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = var.tags
}


resource "azurerm_private_dns_zone" "function_private_dns_zone" {
  name                = "private.function-${var.proyecto}-${var.entorno}.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}