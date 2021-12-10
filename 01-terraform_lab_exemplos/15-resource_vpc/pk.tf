resource "aws_key_pair" "chave_key_clayton" {
  key_name   = "chave_key_terraform_clayton"
  public_key = var.ssh_pub_key # sua chave publica da maquina 
}
