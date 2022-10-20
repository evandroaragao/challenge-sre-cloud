#Create a VPC with using the inputs defined on locals in main.tf
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block

  tags = {
    Name = local.vpc_name
  }
}

#Create subnets using the inputs defined on locals in main.tf
resource "aws_subnet" "public" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_cidr_block
  availability_zone       = "${local.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = local.public_subnet_name
  }
}

resource "aws_subnet" "public2" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public2_subnet_cidr_block
  availability_zone       = "${local.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = local.public2_subnet_name
  }
}

#Creates a default_security_group allowing internet acccess by default
resource "aws_default_security_group" "default" {
  depends_on = [aws_vpc.main]
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creates a security group to be used by the ec2 instance
resource "aws_security_group" "ec2_instance_ec2" {
  depends_on = [aws_vpc.main]
  name        = "${local.instance_name}-sg"
  description = "Security group used by the instance ${local.instance_name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow TCP port 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags               = merge(local.tags, { Name = "${local.instance_name}-sg"})
}

#Creates a security group to be used by the application load balancer
resource "aws_security_group" "alb_sg" {
  depends_on = [aws_vpc.main]
  name        = "alb-sg"
  description = "Security group used by the application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow TCP port 8080"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags               = merge(local.tags, { Name = "alb-sg"})
}

#Add an ingress rule for SSH access to EC2 Instance
resource "aws_security_group_rule" "ec2_ssh" {
  depends_on = [aws_security_group.ec2_instance_ec2]
  type              = "ingress"
  description      = "Allow TCP port 22022 (SSH)"
  from_port         = 22022
  to_port           = 22022
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_instance_ec2.id
}

#Configure an Internet gateway to be used by the new VPC
resource "aws_internet_gateway" "gw" {
  depends_on = [aws_vpc.main]
  vpc_id = aws_vpc.main.id

  tags   = merge(local.tags, { Name = "${local.vpc_name}-igw"})
}

#Configure default route table
resource "aws_default_route_table" "default_route_table" {
  depends_on = [aws_internet_gateway.gw]
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "default_route_table"
  }
}

#Associate public subnet to route table
resource "aws_route_table_association" "public_subnet_association" {
  depends_on = [aws_default_route_table.default_route_table]
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_default_route_table.default_route_table.id
}