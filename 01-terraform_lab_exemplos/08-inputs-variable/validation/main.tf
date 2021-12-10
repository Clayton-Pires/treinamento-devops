# variable "image_id" {
#   type        = string
#   description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."

#   validation {
#     condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
#     error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
#   }
# }

# output "image_id" {
#     value = var.image_id
# }

variable "image_id" {
  type        = string
  description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
  
}
output "image_id" {
    value = var.image_id
}


variable "subnet_id" {
  type        = string
  description = "O id da Subnet para ser usado no servidor."
  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "O valor da subnet_id não é válido, tem que começar com \"subnet-\"."
  }

}
output "subnet_id" {
    value = var.subnet_id
}


variable "tamanho" {
  type        =  number
  description = "O tamanho (gb) para ser usado no servidor."
  validation {
    condition     = var.tamanho >= 8 
    error_message = "O tamanho não é válido, tem que começar ser maior ou igual 8gb."
  }

}
output "tamanho" {
    value = var.tamanho
}


variable "nome_servidor" {
  type        =  string
  description = "O nome para ser usado no servidor."
  validation {
    condition     = length(var.nome_servidor) > 0 
    error_message = "O nome não é válido, o campo não pode ser branco."
  }
}

output "nome_servidor" {
    value = var.nome_servidor
}
