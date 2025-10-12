output "azure_vm_public_ip" {
  description = "The public IP address of the Azure VM"
  value       = azurerm_public_ip.main.ip_address
}