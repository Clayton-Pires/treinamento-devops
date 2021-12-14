provider "aws" {
  region = "sa-east-1"
}

module "criar_instancia_da_erika" {
  source = "github.com/Clayton-Pires/modulo_devops_terraform_clayton.git"
  nome   = "clayton-terraform-modulo"
  tipo   = "t2.micro"
}

# module "criar_instancia_da_erika_micro" {
#   source = "./erika"
#   nome = "Um nome"
#   tipo = "micro"
# }