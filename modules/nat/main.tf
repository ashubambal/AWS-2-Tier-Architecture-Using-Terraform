# allocate elastic IP, this eip will be use for nat-gateway in public subnet pub-sub-1a
resource "aws_eip" "eip_nat_a"{
    domain = "vpc"
    tags = {
      Name = "eip_nat_a"
    }
}

# allocate elastic IP, this eip will be use for nat-gateway in public subnet pub-sub-2b
resource "aws_eip" "eip_nat_b" {
    domain = "vpc"
    tags = { 
        Name ="eip_nat_b"
    }
}

# create nat gateway in public subnet pub-sub-1a
resource "aws_nat_gateway" "nat-a" {
    allocation_id = aws_eip.eip_nat_a.id
    subnet_id = var.pub_sub_1a_id
    tags = {
      Name = "nat-a"
    }
    # to ensure proper ordering, it is recommended to add an explicit dependency
    # on the internet gateway for the vpc.
    depends_on = [var.igw_id]
}

# create nat gateway in public subnet pub-sub-2b
resource "aws_nat_gateway" "nat-b" {
    allocation_id = aws_eip.eip_nat_b.id
    subnet_id = var.pub_sub_2b_id
    tags = {
      Name = "nat-b"
    }
    # to ensure proper ordering, it is recommended to add an explicit dependency
    # on the internet gateway for the vpc.
    depends_on = [var.igw_id]
}

# create private app route table pri-app-rt-a
resource "aws_route_table" "pri-app-rt-a" {
    vpc_id = var.vpc_id
    route {
        cidr_block      = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-a.id
    }
    tags = {
        Name = "pri-app-rt-a" 
    }
}

# associate private app subnet pri-sub-3c with private route table pri-app-rt-a
resource "aws_route_table_association" "pri_sub_3c_with_pri_app_rt_a" {
    subnet_id = var.pri_sub_3c_id
    route_table_id = aws_route_table.pri-app-rt-a.id
}

# associate private app subnet pri-sub-4d with private route table pri-app-rt-b
resource "aws_route_table_association" "pri_sub_4d_with_pri_app_rt_b" {
    subnet_id = var.pri_sub_4d_id
    route_table_id = aws_route_table.pri-app-rt-a.id
}


# create private db route table pri-db-rt-b
resource "aws_route_table" "pri-db-rt-b" {
    vpc_id = var.vpc_id
    route {
        cidr_block      = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-b.id
    }
    tags = {
        Name = "pri-db-rt-b" 
    }
}

# associate private db subnet pri-sub-5e with private route table pri-db-rt-a
resource "aws_route_table_association" "pri_sub_5e_with_pri_app_rt_a" {
    subnet_id = var.pri_sub_5e_id
    route_table_id = aws_route_table.pri-db-rt-b.id
}

# associate private db subnet pri-sub-6f with private route table pri-db-rt-b
resource "aws_route_table_association" "pri_sub_6f_with_pri_app_rt_b" {
    subnet_id = var.pri_sub_6f_id
    route_table_id = aws_route_table.pri-db-rt-b.id
}

