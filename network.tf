resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "The-MAIN-VPC"
  }
}

##### INTERNET GATEWAY ####

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway"
  }
}

####### SUBNETS ##### PUBLIC

resource "aws_subnet" "subnet1_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_for_public1
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Subnet1-Public"
  }
}

resource "aws_subnet" "subnet2_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_for_public2
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Subnet2-Public"
  }
}

###### Subnets ###### PRIVATE

resource "aws_subnet" "subnet3_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_for_private1
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Subnet3-Private"
  }
}

resource "aws_subnet" "subnet4_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_for_private2
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Subnet4-Private"
  }
}

###### NAT GATEWAYS 1/2 and elastic IPs

resource "aws_eip" "elastic_ip1" {
  domain   = "vpc"
}

resource "aws_eip" "elastic_ip2" {
  domain   = "vpc"
}

# NAT1 ##########

resource "aws_nat_gateway" "NAT_GATEWAY1" {
  allocation_id = aws_eip.elastic_ip1.id
  subnet_id     = aws_subnet.subnet1_public.id

  tags = {
    Name = "gw-NAT1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gateway1]
}

##### NAT2 ####

resource "aws_nat_gateway" "NAT_GATEWAY2" {
  allocation_id = aws_eip.elastic_ip2.id
  subnet_id     = aws_subnet.subnet2_public.id

  tags = {
    Name = "gw-NAT2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gateway1]
}

######### ROUTE_TABLES #########

### 1

resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  tags = {
    Name = "public-route-table1"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1_public.id
  route_table_id = aws_route_table.route_table1.id
}

### 2

resource "aws_route_table" "route_table2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  tags = {
    Name = "public-route-table2"
  }
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2_public.id
  route_table_id = aws_route_table.route_table2.id
}


### 3

resource "aws_route_table" "route_table3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GATEWAY1.id
  }

  tags = {
    Name = "private-route-table3"
  }
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet3_private.id
  route_table_id = aws_route_table.route_table3.id
}

### 4


resource "aws_route_table" "route_table4" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GATEWAY2.id
  }

  tags = {
    Name = "private-route-table4"
  }
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.subnet4_private.id
  route_table_id = aws_route_table.route_table4.id
}

