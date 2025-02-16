variable "environment" {
  description = "Nom de l'environnement ('dev' ou 'prod')"
  default     = "dev"
}

variable "redis_password" {
  description = "Mot de passe Redis"
  type        = string
  default     = "securepassword"
  sensitive   = true
}

