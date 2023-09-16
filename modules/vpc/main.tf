# create vpc
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.project_name}-vpc"
    }
}

# create internet gateway and attach to it to vpc
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "${var.project_name}-igw"
    }
}

# use data source to get all avaability zones in region
data "aws_availability_zones" "available_zone" {}

# create pubic subnet pub_sub_1a
resource "aws_subnet" "pub_sub_1a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_sub_1a_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[0]
    map_public_ip_on_launch = true

    tags = {
      Name = "pub_sub_1a"
    }
}

# create public subnet pub_sub_2b
resource "aws_subnet" "pub_sub_2b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_sub_2b_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[1]
    map_public_ip_on_launch = true

    tags = {
      Name = "pub_sub_2b"
    }
}

# create route table 
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "Public-rt" 
    }
}

# add public route to the route table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# associate public subnet pub_sub_1a to public route table
resource "aws_route_table_association" "pub_sub_1a_route_table_association" {
    subnet_id = aws_subnet.pub_sub_1a.id
    route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet pub_sub_2b to public route table
resource "aws_route_table_association" "pub_sub_2b_route_tabe_association" {
    subnet_id = aws_subnet.pub_sub_2b.id
    route_table_id = aws_route_table.public_route_table.id
}

# create private app subnet pri_sub_3c
resource "aws_subnet" "pri_sub_3c" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_3c_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[0]
    map_public_ip_on_launch = false

    tags = {
      Name = "pri_sub_3c"
    }
}

# create private app subnet pri_sub_4d
resource "aws_subnet" "pri_sub_4d" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_4d_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[1]
    map_public_ip_on_launch = false

    tags = {
      Name = "pri_sub_4d"
    }
}

# create private db subnet pri_sub_5e
resource "aws_subnet" "pri_sub_5e" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_5e_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[0]
    map_public_ip_on_launch = false

    tags = {
      Name = "pri_sub_5e"
    }
}

# create private db subnet pri_sub_6f
resource "aws_subnet" "pri_sub_6f" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_6f_cidr
    availability_zone = data.aws_availability_zones.available_zone.names[1]
    map_public_ip_on_launch = false

    tags = {
      Name = "pri_sub_6f"
    }
}
