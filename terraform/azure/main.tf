#######################################
# Resource Group Configuration
#######################################
resource "azurerm_resource_group" "main" {
  name = "${var.project_name}-rg"
  location = var.azure_location
}

#######################################
# Networking Configuration
#######################################

# Virtual Network and Subnet
resource "azurerm_virtual_network" "main" {
  name = "${var.project_name}-vn"
  location = azurerm_resource_group.main.location
  address_space = [var.vn_cidr]
  resource_group_name = azurerm_resource_group.main.name
}

# Subnets
resource "azurerm_subnet" "main" {
  name = "${var.project_name}-subnet"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes     = [var.azure_subnet_cidr]
}

#######################################
# Security Groups
#######################################
resource "azurerm_network_security_group" "main" {
  name = "${var.project_name}-sg"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name = "SSH"
    priority = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip_for_ssh
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IP 
resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# Network Interface (NIC)   -- connects subnet with your vm
resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Associate the NSG with the NIC    -- secuity gate at nsg
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}


#######################################
# Virtual Machine Configuration
#######################################
# The Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name = "${var.project_name}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  size = "Standard_B1s"      # t2.micro
  network_interface_ids = [azurerm_network_interface.main.id]

  # This tells Azure not to require a password and to use an SSH key instead
  disable_password_authentication = true

  admin_username = "ubuntu"

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub") # Assumes you have an SSH key here
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(file("${path.module}/user-data.sh"))
}