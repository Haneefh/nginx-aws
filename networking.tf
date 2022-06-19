### Get the currrent Public Ip  ####
data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

#### VPC ####
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.dns_hostnames
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true

  tags = {
    Name = "${var.name}_vpc"
  }
}


###### Public Subnet ##### 
resource "aws_subnet" "pubsubnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}_public"
  }
}


###### Internet Gateway ##### 

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_gw"
  }
}


##### Route table public and Association #### 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_public_rt"
  }
}

resource "aws_route" "default_rt" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.pubsubnet.id
  route_table_id = aws_route_table.public_rt.id
}


##### NACL for Public Subnet ###### 
resource "aws_network_acl" "nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.pubsubnet.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${chomp(data.http.my_public_ip.body)}/32"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${chomp(data.http.my_public_ip.body)}/32"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  tags = {
    Name = "${var.name}_nacl"
  }
}

#### Security group for ec2 instace ### 

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow http"
  description = "Allow http traffic from Public"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow http from Public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}_ec2_sg"
  }
}

