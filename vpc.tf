resource "aws_vpc" "demo-ansible-autoupdate" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    "Name" = "demo-ansible-autoupdate"
  }
}

resource "aws_subnet" "public-sub" {
  vpc_id     = aws_vpc.demo-ansible-autoupdate.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]

  tags = {
    Name = "public-sub-autoupdate-vpc"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id     = aws_vpc.demo-ansible-autoupdate.id
  cidr_block = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]

  tags = {
    Name = "private-sub-autoupdate-vpc"
  }
}

resource "aws_internet_gateway" "demo-ansibleAutoUpdate-igw" {
  vpc_id = aws_vpc.demo-ansible-autoupdate.id

  tags = {
    Name = "demo-ansibleAutoUpdate-igw"
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.demo-ansible-autoupdate.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-ansibleAutoUpdate-igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.demo-ansible-autoupdate.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "Private" {
  subnet_id      = aws_subnet.private-sub.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_security_group" "allowingssh" {
  name        = "allow_ssh"
  description = "Allow ssh traffic in vpc"
  vpc_id      = aws_vpc.demo-ansible-autoupdate.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowig_ssh"
  }
}

resource "aws_security_group" "allowingweb" {
  name        = "allow_web"
  description = "Allow web traffic in vpc"
  vpc_id      = aws_vpc.demo-ansible-autoupdate.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowig_web"
  }
}

resource "aws_security_group" "splunksg" {
  name        = "splunksg"
  description = "open necessary ports in splunk instance"
  vpc_id      = aws_vpc.demo-ansible-autoupdate.id

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Splunk Enterprise SG"
  }
}