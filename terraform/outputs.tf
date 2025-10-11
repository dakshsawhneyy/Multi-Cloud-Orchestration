output "vpc_id" {
  description = "Output for VPC ID"
  value = module.vpc.vpc_id
}

output "ec2_ip" {
  description = "Output for EC2 Public IP"
  value = module.ec2_instance.public_ip
}

output "my_sg_id" {
  description = "Output for my Security Group"
  value = aws_security_group.my_sg.id
}

output "azure_vm_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = azurerm_public_ip.main.ip_address
}