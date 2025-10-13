/* 
  Basically the approach is something like we using inventory.tftpl to fetch dynamic ips of the instances created
  tftpl stands for terraform template
  we using inventory.tf so it can inject these dynamic values into tftpl file and saving inventory.ini inside ansible folder

  It's job is to create inventory file dynamically
*/

resource "local_file" "ansible_inventory" {
  # takes template file, fills with actual ips
  content = templatefile("${path.module}/inventory.tftpl", {
    workspace = terraform.workspace,
    aws_ips    = terraform.workspace == "aws" ? module.ec2_instance[*].public_ip : [],
    azure_ips  = terraform.workspace == "azure" ? azurerm_public_ip.main[*].ip_address : []
  })

  # output file
  filename = "${path.root}/../ansible/inventory.ini"
}
