#######################################
# AWS Outputs
#######################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = terraform.workspace == "aws" ? module.vpc[0].vpc_id : "N/A (Not in aws workspace)"
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = terraform.workspace == "aws" ? module.ec2_instance[0].public_ip : "N/A (Not in aws workspace)"
}

output "aws_security_group_id" {
  description = "The ID of the AWS Security Group"
  value       = terraform.workspace == "aws" ? aws_security_group.my_sg[0].id : "N/A (Not in aws workspace)"
}

#######################################
# Azure Outputs
#######################################

output "azure_resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = terraform.workspace == "azure" ? azurerm_resource_group.main[0].name : "N/A (Not in azure workspace)"
}

output "azure_vm_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = terraform.workspace == "azure" ? azurerm_public_ip.main[0].ip_address : "N/A (Not in azure workspace)"
}

output "azure_virtual_network_name" {
  description = "The name of the Azure Virtual Network"
  value       = terraform.workspace == "azure" ? azurerm_virtual_network.main[0].name : "N/A (Not in azure workspace)"
}

output "azure_ssh_command" {
  description = "The command to SSH into the Azure VM"
  value       = terraform.workspace == "azure" ? "ssh ubuntu@${azurerm_public_ip.main[0].ip_address} -i id_rsa" : "N/A (Not in azure workspace)"
  sensitive   = true # Hides the value in the console output for security
}

#######################################
# General Outputs
#######################################

output "local_file_name" {
  description = "The filename of the generated Ansible inventory"
  value       = local_file.ansible_inventory.filename
}