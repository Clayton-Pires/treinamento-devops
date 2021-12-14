provider "aws" {
  region = "sa-east-1"
}

# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # ou ["099720109477"] ID master com permissão para busca

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # exemplo de como listar um nome de AMI - 'aws ec2 describe-images --region us-east-1 --image-ids ami-09e67e426f25ce0d7' https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  }
}

resource "aws_instance" "maquina_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  key_name      = "cert-turma3-clayton-dev"
  associate_public_ip_address = true
 
  subnet_id      = "subnet-00c59894f53620c61"

  root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "k8s-master-clayton"
  }
  vpc_security_group_ids = [aws_security_group.acessos_master_single_master.id]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "cert-turma3-clayton-dev"
  associate_public_ip_address = true

  subnet_id      = "subnet-00c59894f53620c61"

  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-node-clayton-${count.index + 1}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers_single_master.id]
  count         = 3
}

resource "aws_security_group" "acessos_master_single_master" {
  name        = "acessos_master_single_master_clayton"
  description = "acessos_master_single_master inbound traffic"
  vpc_id = "vpc-0a957401e8ad3cade"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  #["${chomp(data.http.myip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "Liberando app nodejs para o mundo"
      from_port        = 30000
      to_port          = 30000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    } 
    # {
    #   cidr_blocks      = []
    #   description      = ""
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     # "${aws_security_group.acessos_workers_single_master.id}", não pode porque é circular
    #     #"sg-015a0fb8546987fea", # security group do acessos_workers_single_master
    #     # "sg-292334788sh232u22", # security group do nginx
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
  #   {
  #     cidr_blocks      = [
  #       "0.0.0.0/0",
  #     ]
  #     description      = ""
  #     from_port        = 0
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     protocol         = "tcp"
  #     security_groups  = []
  #     self             = false
  #     to_port          = 65535
  #   },
   ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master_single_master_clayton"
  }
}


resource "aws_security_group" "acessos_workers_single_master" {
  name        = "acessos_workers_single_master_clayton"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id = "vpc-0a957401e8ad3cade"


  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  #["${chomp(data.http.myip.body)}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
    # {
    #   cidr_blocks      = []
    #   description      = ""
    #   from_port        = 0
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "-1"
    #   security_groups  = [
    #     "${aws_security_group.acessos_master_single_master.id}",
    #   ]
    #   self             = false
    #   to_port          = 0
    # },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_workers_single_master_clayton"
  }
}

#liberar acesso circular entre master e workers 
resource "aws_security_group_rule" "k8s_ingress_acesso_workers" {
  type              = "ingress"
  description       = "Acsso do master no worker."
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.acessos_workers_single_master.id
  security_group_id = aws_security_group.acessos_master_single_master.id
}


resource "aws_security_group_rule" "k8s_ingress_acesso_master" {
  type              = "ingress"
  description       = "Acsso do worker no master."
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  source_security_group_id = aws_security_group.acessos_master_single_master.id
  security_group_id = aws_security_group.acessos_workers_single_master.id
}


# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip} - ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@${aws_instance.maquina_master.public_dns} -o ServerAliveInterval=60",
    "sg master - ${aws_security_group.acessos_workers_single_master.id}"
  ]
}

# terraform refresh para mostrar o ssh
output "maquina_workers" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip} - ssh -i ~/cert-turma3-clayton-dev.pem ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}