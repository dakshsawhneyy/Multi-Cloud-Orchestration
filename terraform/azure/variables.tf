variable "project_name" {
   default = "multi-cloud-orchestration"
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

variable "my_ip_for_ssh" {
  type = string
  default = "152.58.184.138/32"
}

variable "azure_location" {
  type = string
  default = "Central India"
}