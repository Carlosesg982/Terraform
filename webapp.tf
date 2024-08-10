resource "azurerm_app_service_plan" "app_service_plan" {
    name                = "asp-${var.proyecto}-${var.entorno}"
    location            = var.ubicacion
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "Linux"
    reserved            = true
    
    sku {
        tier = "Standard"
        size = "B1"
    }

    tags = var.tags
}

resource "azurerm_container_registry" "acr" {
    name                = "acr${var.proyecto}${var.entorno}"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.ubicacion
    sku                 = "Basic"
    admin_enabled       = true

    tags = var.tags
}

resource "azurerm_app_service" "webapp1"{ 
    name                = "ui-${var.proyecto}-${var.entorno}"
    location            = var.ubicacion
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

    app_settings = {
        "DOCKER_REGISTRY_SERVER_URL"         = "https://${azurerm_container_registry.acr.login_server}"
        "DOCKER_REGISTRY_SERVER_USERNAME"    = azurerm_container_registry.acr.admin_username
        "DOCKER_REGISTRY_SERVER_PASSWORD"    = azurerm_container_registry.acr.admin_password
        "WEBSITES_VNET_ROUTE_ALL"                      = "1"
    }

    site_config {
        always_on = true
        linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.proyecto}/ui:latest"
        vnet_route_all_enabled = true
    }

    depends_on = [
        azurerm_app_service_plan.app_service_plan,
        azurerm_container_registry.acr,
        azurerm_subnet.subnetweb]

    tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp1_vnet_integration" {
    app_service_id = azurerm_app_service.webapp1.id
    subnet_id      = azurerm_subnet.subnetweb.id
    
    depends_on = [
        azurerm_app_service.webapp1
    ]
}

resource "azurerm_app_service" "webapp2"{
    name                = "api-${var.proyecto}-${var.entorno}"
    location            = var.ubicacion
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

    app_settings = {
        "DOCKER_REGISTRY_SERVER_URL"         = "https://${azurerm_container_registry.acr.login_server}"
        "DOCKER_REGISTRY_SERVER_USERNAME"    = azurerm_container_registry.acr.admin_username
        "DOCKER_REGISTRY_SERVER_PASSWORD"    = azurerm_container_registry.acr.admin_password
        "WEBSITES_VNET_ROUTE_ALL"                      = "1"
    }

    site_config {
        always_on = true
        linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.proyecto}/api:latest"
        vnet_route_all_enabled = true
    }

    depends_on = [
        azurerm_app_service_plan.app_service_plan,
        azurerm_container_registry.acr,
        azurerm_subnet.subnetweb]

    tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp2_vnet_integration" {
    app_service_id = azurerm_app_service.webapp2.id
    subnet_id      = azurerm_subnet.subnetweb.id

    depends_on = [
        azurerm_app_service.webapp2
    ]
}