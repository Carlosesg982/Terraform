variable "proyecto"{
  default     = "webapp"
  description = "nombre del proyecto"
}

variable "entorno"{
  default     = "dev"
  description = "entorno de desarrollo"
}

variable "ubicacion"{
  default     = "East US 2"
  description = "ubicación de los recursos de azure"
}

variable "tags"{
  default     = {
    environment = "dev"
    proyect = "webapp"
    created_by = "Terraform"
  }
  description = "etiquetas de los recursos"
}