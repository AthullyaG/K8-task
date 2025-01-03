provider "aws" {
  region = "us-west-2"  # Update this based on your region
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Update this based on your availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"  # Update this based on your availability zone
  map_public_ip_on_launch = true
}

# Reference to the existing IAM role
data "aws_iam_role" "cluster_role" {
  name = "eks-cluster-role"  # Reference the existing IAM role by name
}

# Create EKS cluster
resource "aws_eks_cluster" "web_app_cluster" {
  name     = "web-app-cluster"
  role_arn = data.aws_iam_role.cluster_role.arn  # Use the ARN of the existing role

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id
    ]
  }
}

# Create Route Tables (optional, to route traffic)
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

# Associate subnets with the route table
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main_route_table.id
}
