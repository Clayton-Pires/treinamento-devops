variable key_pair_name {
  type        = string
  default     = "cert-turma3-clayton-dev"
}

variable subnet-az-a {
  type        = string
  default     = "subnet-00c59894f53620c61"
}

variable vpc_id {
  type        = string
  default     = "vpc-0a957401e8ad3cade"
  description = "description"
}

variable meu_nome {
  type        = string
  default     = "clayton"
  description = "Adicionar seu nome"
}

variable key_pair_path {
  type        = string
  default     = "~/"
  description = "Caminho de onda esta a chave privada"
}

