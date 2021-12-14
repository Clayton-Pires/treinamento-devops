terraform {
  backend "remote" {
    organization = "clayton_corp"

    workspaces {
      name = "modular_terraform"
    }
  }
}
