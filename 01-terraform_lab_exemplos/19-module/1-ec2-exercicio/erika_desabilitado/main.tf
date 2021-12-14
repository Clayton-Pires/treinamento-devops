terraform {
  required_version = ">= 0.12" # colocando compatibilidade do terraform para 0.12
}

resource "aws_instance" "web" {
  ami           = "ami-0e66f5495b4efdd0f"
  subnet_id = "subnet-00c59894f53620c61"
  instance_type = var.tipo
  key_name = "cert-turma3-clayton-dev" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0c40cb54147ae844b"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "${var.nome}",
    Itau = true
  }
}


