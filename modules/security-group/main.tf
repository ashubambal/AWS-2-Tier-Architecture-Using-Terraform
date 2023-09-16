# create SG for ALB
resource "aws_security_group" "alb_sg" {
    name = "alb security group"
    description = "enable http/https access on port 443/80"
    vpc_id = var.vpc_id

    ingress {
        description = "http access"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "https access"
        from_port = 443
        to_port  = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Allow outgoining everything"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "alb-sg"
    }
}

# create security group for the Client
resource "aws_security_group" "client_sg" {
    description = "enable http/https aceess on port 80 for alb_sg"
    name = "client_sg"
    vpc_id = var.vpc_id

    ingress {
        description = "http access"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
        description = "Allow outgoining everything"
        from_port = 0
        to_port = 0
        protocol =-1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "client_sg"
    }
}

# create security group for the the database
resource "aws_security_group" "db_sg" {
    description = "enable mysql access on port 3306 form client-sg"
    name = "db_sg"
    vpc_id = var.vpc_id

    ingress {
        description = "mysql access"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.client_sg.id]
    }

    egress {
        description = "mysql outgoinig"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "db-sg"
    } 
}


