provider "aws" {
  region = "us-west-2"  
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"  
  map_public_ip_on_launch = true
}


data "aws_iam_role" "cluster_role" {
  name = "eks-cluster-role"  
}


resource "aws_eks_cluster" "web_app_cluster" {
  name     = "web-app-cluster"
  role_arn = data.aws_iam_role.cluster_role.arn  

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id
    ]
  }
}


resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}


resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main_route_table.id
}
