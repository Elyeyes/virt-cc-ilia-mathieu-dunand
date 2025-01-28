# variable "project_id" {
#   type        = string
#   description = "d204ffce-1979-49fa-bc47-3723d74dbc2d"
# }

# variable "vpc_id" {
#   description = "a44edd5c-183f-45ff-a9ab-720837671ebd"
#   type        = string
# }

variable "db_password" {
  description = "Le mot de passe de la base de données"
  type        = string
  sensitive   = true
}