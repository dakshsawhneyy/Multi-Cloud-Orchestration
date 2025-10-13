variable "project_name" {
   default = "multi-cloud-orchestration"
   type = string
}

variable "vpc_cidr" {
  description = "This provides the cidr block for vpc"
  default = "10.0.0.0/16"
  type = string
}

variable "vn_cidr" {
  type = string
  default = "10.1.0.0/16"
}

variable "azure_subnet_cidr" {
  type = string
  default = "10.1.1.0/24"
}

variable "environment" {
  default = "dev"
  type = string
}

variable "single_nat_gateway" {
  default = true
  type = bool
}

variable "my_ip_for_ssh" {
  type = string
  default = "152.58.184.138/32"
}

variable "azure_location" {
  type = string
  default = "Central India"
}

variable "aws_instance_count" {
  type = number
  default = 3
}
