output "vpc_id" {
  description = "Output for VPC ID"
  value = terraform.workspace == "aws" ? module.vpc[0].vpc_id : "N/A (Not in aws workspace)"
}

output "ec2_ip" {
  description = "Output for EC2 Public IP"
  value = terraform.workspace == "aws" ? module.ec2_instance[0].public_ip : "N/A (Not in aws workspace)"
}

output "my_sg_id" {
  description = "Output for my Security Group"
  value = terraform.workspace == "aws" ? aws_security_group.my_sg[0].id : "N/A (Not in aws workspace)"
}

output "azure_vm_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = terraform.workspace == "azure" ? azurerm_public_ip.main[0].ip_address : "N/A (Not in azure workspace)"
}

output "local_file_name" {
  value = local_file.ansible_inventory.filename
}