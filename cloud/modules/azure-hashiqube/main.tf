resource "null_resource" "hashiqube" {
  triggers = {
    deploy_to_aws       = var.deploy_to_aws
    deploy_to_azure     = var.deploy_to_azure
    deploy_to_gcp       = var.deploy_to_gcp
    whitelist_cidr      = var.whitelist_cidr
    my_ipaddress        = var.my_ipaddress
    ssh_public_key      = var.ssh_public_key
    aws_hashiqube_ip    = var.aws_hashiqube_ip
    gcp_hashiqube_ip    = var.gcp_hashiqube_ip
    vault_enabled       = lookup(var.vault, "enabled")
    vault_version       = lookup(var.vault, "version")
    azure_region        = var.azure_region
    azure_instance_type = var.azure_instance_type
  }
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "hashiqube" {
  name     = "hashiqube"
  location = var.azure_region
  tags = {
    environment = "hashiqube"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "hashiqube" {
  name                = "hashiqube"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  tags = {
    environment = "hashiqube"
  }
}

# Create subnet
resource "azurerm_subnet" "hashiqube" {
  name                 = "hashiqube"
  resource_group_name  = azurerm_resource_group.hashiqube.name
  virtual_network_name = azurerm_virtual_network.hashiqube.name
  address_prefixes      = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "hashiqube" {
  name                = "hashiqube"
  location            = azurerm_resource_group.hashiqube.location
  resource_group_name = azurerm_resource_group.hashiqube.name
  allocation_method   = "Static"
  tags = {
    environment = "hashiqube"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_ipaddress" {
  name                = "hashiqube"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  security_rule {
    name                        = "myipaddress"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes      = ["${var.my_ipaddress}/32"]
    destination_address_prefixes = [azurerm_network_interface.hashiqube.private_ip_address]
  }
  tags = {
    environment = "hashiqube"
  }
}

resource "azurerm_network_security_group" "azure_hashiqube_ip" {
  count               = var.deploy_to_azure ? 1 : 0
  name                = "azure_hashiqube_ip"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  security_rule {
    name                        = "azure_hashiqube_ip"
    priority                    = 1002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes      = ["${azurerm_public_ip.hashiqube.ip_address}/32"]
    destination_address_prefixes = [azurerm_network_interface.hashiqube.private_ip_address]
  }
  tags = {
    environment = "hashiqube"
  }
}

resource "azurerm_network_security_group" "aws_hashiqube_ip" {
  count               = var.deploy_to_aws ? 1 : 0
  name                = "aws_hashiqube_ip"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  security_rule {
    name                        = "aws_hashiqube_ip"
    priority                    = 1003
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes      = ["${var.aws_hashiqube_ip}/32"]
    destination_address_prefixes = [azurerm_network_interface.hashiqube.private_ip_address]
  }
  tags = {
    environment = "hashiqube"
  }
}

resource "azurerm_network_security_group" "gcp_hashiqube_ip" {
  count               = var.deploy_to_gcp ? 1 : 0
  name                = "gcp_hashiqube_ip"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  security_rule {
    name                        = "gcp_hashiqube_ip"
    priority                    = 1004
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes      = ["${var.gcp_hashiqube_ip}/32"]
    destination_address_prefixes = [azurerm_network_interface.hashiqube.private_ip_address]
  }
  tags = {
    environment = "hashiqube"
  }
}

resource "azurerm_network_security_group" "whitelist_cidr" {
  count               = var.whitelist_cidr != "" ? 1 : 0
  name                = "whitelist_cidr"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.hashiqube.name
  security_rule {
    name                        = "whitelist_cidr"
    priority                    = 1005
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes      = [var.whitelist_cidr]
    destination_address_prefixes = [azurerm_network_interface.hashiqube.private_ip_address]
  }
  tags = {
    environment = "hashiqube"
  }
}

# Create network interface
resource "azurerm_network_interface" "hashiqube" {
  name                      = "hashiqube"
  location                  = var.azure_region
  resource_group_name       = azurerm_resource_group.hashiqube.name
  ip_configuration {
    name                          = "hashiqube"
    subnet_id                     = azurerm_subnet.hashiqube.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hashiqube.id
  }
  tags = {
    environment = "hashiqube"
  }
}

data "template_file" "hashiqube_user_data" {
  template = file("${path.module}/../../modules/shared/startup_script")
  vars = {
    HASHIQUBE_AZURE_IP = azurerm_public_ip.hashiqube.ip_address
    HASHIQUBE_GCP_IP   = var.gcp_hashiqube_ip == null ? "" : var.gcp_hashiqube_ip
    HASHIQUBE_AWS_IP   = var.aws_hashiqube_ip == null ? "" : var.aws_hashiqube_ip
    VAULT_ENABLED      = lookup(var.vault, "enabled")
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "hashiqube" {
  name                  = "hashiqube"
  location              = var.azure_region
  size                  = var.azure_instance_type
  admin_username        = "ubuntu"
  resource_group_name   = azurerm_resource_group.hashiqube.name
  network_interface_ids = [azurerm_network_interface.hashiqube.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.ssh_public_key)
  }
  custom_data = base64gzip(data.template_file.hashiqube_user_data.rendered)
  tags = {
    environment = "hashiqube"
  }
}
