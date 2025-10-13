# =============================================================================
# VPC CONFIGURATION
# =============================================================================
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}"
  cidr = "${var.vpc_cidr}"

  count = terraform.workspace == "aws" ? 1 : 0

  azs = local.azs
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets

  # Enable NAT gateway
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  # Internet Gateway
  create_igw = true

  # This tells the public subnets to automatically assign a public IP to any instance launched in them.
  map_public_ip_on_launch = true 
}


# =============================================================================
# Security Groups CONFIGURATION
# =============================================================================
resource "aws_security_group" "my_sg" {
  name = "${var.project_name}-my_sg"
  description = "Allows SSH and HTTP traffic"
  vpc_id = module.vpc[0].vpc_id

  count = terraform.workspace == "aws" ? 1 : 0

  # Rule 1: Allow SSH traffic from your IP address
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  # Rule 2: Allow HTTP traffic from anywhere on the internet
  ingress {
    from_port   = 80
    to_port     =  80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This is the universal code for "anywhere"
  }
  # Rule 3: Allow HTTPS traffic from anywhere on the internet
  ingress {
    from_port   = 443
    to_port     =  443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This is the universal code for "anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 = all protocols
    cidr_blocks = ["0.0.0.0/0"] # anywhere
  }

  tags = local.common_tags
}


# =============================================================================
# EC2 CONFIGURATION
# =============================================================================

# Key Pair Creation
resource "aws_key_pair" "main" {
  count = terraform.workspace == "aws" ? 1 : 0
  key_name = "${var.project_name}-key"
  public_key = file("${path.module}/id_rsa.pub")
}

# EC2 Creation
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-ec2-${count.index+1}"     # count.index is internal value to count index starting from 0

  count = terraform.workspace == "aws" ? var.aws_instance_count : 0

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.main[0].key_name
  subnet_id     = module.vpc[0].public_subnets[0]

  # Attach web security group to ssh into web_server
  vpc_security_group_ids = [aws_security_group.my_sg[0].id]

  # Attaching user_data with EC2 -- my script acts as configuration management
  # user_data = templatefile("${path.module}/user-data.sh", {})
  user_data = null    # Introducing Ansible 

  tags = local.common_tags
}