###Criar ec2
resource "aws_instance" "web" {
  subnet_id                   = aws_subnet.my_subnet_a.id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.chave_key_clayton.key_name # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id] #["sg-0c40cb54147ae844b"]
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {

    Name = "ec2_clayton_terraform"
  }

  depends_on = [
    aws_security_group.allow_ssh
  ]
}


data "http" "meuip" {
  url = "http://ipv4.icanhazip.com"
}


#mostrando os ips e dns e montando a strig de conexão forma reduzida
# output "public_ip_dns" {
#   value = [
#     for web in aws_instance.web2 :
#     <<EOF
#      Public IP : ${web.public_ip} 
#      Public DNS: ${web.public_dns}
#      ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@${web.public_ip}
#     EOF
#   ]
# }


#mostrando os ips e dns e montando a strig de conexão forma convecional
# output "public_ip" {
#     value = aws_instance.web.public_ip
# }
# output "public_dns" {
#     value = aws_instance.web.public_dns
# }
# output "ssh_dns" {
#     value = "ssh -i cert-turma3-clayton-dev.pem ubuntu@${aws_instance.web.public_dns}"
# }

# output "ssh_ip" {
#     value = [
#            <<EOF
#            ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@${aws_instance.web.public_ip}
#            EOF
#     ]
# }