###Criando uma VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.40.32.0/20" # uma classe de IP
  instance_tenancy = "default"       # - (Optional) A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr.
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-turma3-clayton-tf"
  }
}

# output "name" {
#   value = aws_vpc.main.id
# }

###Criando subnets
resource "aws_subnet" "my_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.40.33.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vpc-turma3-clayton-tf-subnet_1a"
  }
}


resource "aws_subnet" "my_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.40.34.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "vpc-turma3-clayton-tf-subnet_1b"
  }
}

resource "aws_subnet" "my_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.40.35.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "vpc-turma3-clayton-tf-subnet_1c"
  }
}

###criando internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws_internet_gateway_clayton_terraform"
  }
}


###criando rout table  
resource "aws_route_table" "rt_terraform" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = aws_internet_gateway.gw.id
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "route_table_clayton_terraform"
  }
}


###Associar rout table 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet_a.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.my_subnet_b.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.my_subnet_c.id
  route_table_id = aws_route_table.rt_terraform.id
}




#10.40.32.0/20 CDIR 
#10.40.33.0/24 subnets zone 1a
#10.40.34.0/24 subnets zone 1b
#10.40.35.0/24 subnets zone 1c
# id=vpc-01213731123b8cf8a
#ssh -i id_rsa ubuntu@ec2-3-93-236-30.compute-1.amazonaws.com 