
# resource "aws_instance" "web2" {
#   subnet_id = "subnet-02d7741675f030d69"
#   ami = "ami-083654bd07b5da81d"
#   instance_type = "t2.micro"
#   key_name = "chave_key" # a chave que vc tem na maquina pessoal
#   associate_public_ip_address = true
#   vpc_security_group_ids = ["sg-083654bd07b5da81d"]
#   root_block_device {
#     encrypted = true
#     volume_size = 8
#   }
#   tags = {
#     Name = "ec2-clayton-tf"
#   }
# }
provider "aws" {
  region = "sa-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

# output ip {
#   value       = data.http.myip.body
#   description = "output de ip"
# }


resource "aws_security_group" "allow_ssh" {
  name        = "libera_ssh_clayton_tf"
  description = "Allow SSH inbound traffic"
  vpc_id = "vpc-0a957401e8ad3cade"
  
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp( data.http.myip.body )}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "libera_ssh_clayton_tf"
  }
 
}


# output dns {
#   value       = aws_instance.web.public_dns
#   description = "dns para conexão ssh"
# }

resource "aws_instance" "web" {
  subnet_id = "subnet-00c59894f53620c61"
  ami = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name = "cert-turma3-clayton-dev" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]   #["sg-0c40cb54147ae844b"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
  
    Name = "ec2_clayton_keys_tf"
  }
  depends_on = [
    aws_security_group.allow_ssh
  ]
}


# output "public_ip" {
#     value = aws_instance.web.public_ip
# }
# output "public_dns" {
#     value = aws_instance.web.public_dns
# }
# output "ssh_dns" {
#     value = "ssh -i cert-turma3-clayton-dev.pem ubuntu@${aws_instance.web.public_dns}"
# }

output "ssh_ip" {
    value = [
           <<EOF
           ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@${aws_instance.web.public_ip}
           EOF
    ]
}



# resource "aws_key_pair" "chave_key" {
#   key_name   = "chave_key_clayton_tf"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYRgX8yBrU7M55RitCrEiqisYoTr6cDJbm1vmIAhsSphBfR2boND9cUq8wqxU04nHK4Ch7UHJWFEzN4nODsLNUV2O8SyNkqt2LTdGTWCvjSd+MGV0JkDykW3Z5HBLLzNtb2HDrOkVX1zfqn4OpSgpHVEuQGnIVbL4v38Q4Kdi/yCiOuvlkdDPnZKLOSJMyAgBXcsnQTj9gm7B7B/oUkFJkz0zoN7OvI6plHjuoKoC6BcsmeXAhY6TrYC3xPpx5DUOHZd0k6c4/1g4DNWW2DcUq3AyS+9dNaCivXsZfzxAU1UdZS7UrLNoFPTLiyfXWhH4J9BQA6ebzpy6b5V11lW2g6W6H04ePg5K5SY5lxvL5YI1DIwIARaZUnTlzcX3+SpTra/DYmwIwBPOsWWarom8HodoYTKbl24rZslMuOVWL4PNLQB/rDmP80ZEebpxUO5EHEqHF3/jIntbvLFyQ3rszP+PPaZRPcuLTj6dnbEwMWEvkMAVpLAYoFsNZ4v5sngs= ubuntu@turma3-clayton-dev" # sua chave publica da maquina 
# }


