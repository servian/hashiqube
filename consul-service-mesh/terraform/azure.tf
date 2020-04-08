// provider "azurerm" {
// }
//
// resource "random_id" "name_suffix" {
//   byte_length = 4
// }
//
// # Create a resource group if it doesn’t exist
// resource "azurerm_resource_group" "myterraformgroup" {
//   name     = "myResourceGroup-${random_id.name_suffix.hex}"
//   location = "eastus"
//
//   tags = {
//     environment = "Terraform Demo"
//   }
// }
//
// # Create virtual network
// resource "azurerm_virtual_network" "myterraformnetwork" {
//   name                = "myVnet-${random_id.name_suffix.hex}"
//   address_space       = ["10.0.0.0/16"]
//   location            = "eastus"
//   resource_group_name = azurerm_resource_group.myterraformgroup.name
//
//   tags = {
//     environment = "Terraform Demo"
//   }
// }
//
// # Create subnet
// resource "azurerm_subnet" "myterraformsubnet" {
//   name                 = "mySubnet-${random_id.name_suffix.hex}"
//   resource_group_name  = azurerm_resource_group.myterraformgroup.name
//   virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
//   address_prefix       = "10.0.1.0/24"
// }
//
// # Create public IPs
// resource "azurerm_public_ip" "myterraformpublicip" {
//   name                = "myPublicIP-${random_id.name_suffix.hex}"
//   location            = "eastus"
//   resource_group_name = azurerm_resource_group.myterraformgroup.name
//   allocation_method   = "Dynamic"
//
//   tags = {
//     environment = "Terraform Demo"
//   }
//   depends_on = [
//     azurerm_resource_group.myterraformgroup
//   ]
// }
//
// # Create Network Security Group and rule
// resource "azurerm_network_security_group" "myterraformnsg" {
//   name                = "myNetworkSecurityGroup-${random_id.name_suffix.hex}"
//   location            = "eastus"
//   resource_group_name = "azurerm_resource_group.myterraformgroup.name"
//
//   security_rule {
//     name                       = "SSH"
//     priority                   = 1001
//     direction                  = "Inbound"
//     access                     = "Allow"
//     protocol                   = "Tcp"
//     source_port_range          = "*"
//     destination_port_range     = "22"
//     source_address_prefix      = "*"
//     destination_address_prefix = "*"
//   }
//
//   security_rule {
//     name                       = "Consul"
//     priority                   = 1002
//     direction                  = "Inbound"
//     access                     = "Allow"
//     protocol                   = "Tcp"
//     source_port_range          = "*"
//     destination_port_range     = "8500"
//     source_address_prefix      = "110.175.137.98/32"
//     destination_address_prefix = "*"
//   }
//
//   tags = {
//     environment = "Terraform Demo"
//   }
// }
//
// # Create network interface
// resource "azurerm_network_interface" "myterraformnic" {
//   name                      = "myNIC-${random_id.name_suffix.hex}"
//   location                  = "eastus"
//   resource_group_name       = azurerm_resource_group.myterraformgroup.name
//   network_security_group_id = azurerm_network_security_group.myterraformnsg.id
//
//   ip_configuration {
//     name                          = "myNicConfiguration"
//     subnet_id                     = azurerm_subnet.myterraformsubnet.id
//     private_ip_address_allocation = "Dynamic"
//     public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
//   }
//
//   tags = {
//     environment = "Terraform Demo"
//   }
// }
//
// # Generate random text for a unique storage account name
// resource "random_id" "randomId" {
//   keepers = {
//     # Generate a new ID only when a new resource group is defined
//     resource_group = "${azurerm_resource_group.myterraformgroup.name}"
//   }
//
//   byte_length = 8
// }
//
// # Create storage account for boot diagnostics
// resource "azurerm_storage_account" "mystorageaccount" {
//   name                     = "diag${random_id.randomId.hex}"
//   resource_group_name      = azurerm_resource_group.myterraformgroup.name
//   location                 = "eastus"
//   account_tier             = "Standard"
//   account_replication_type = "LRS"
//
//   tags = {
//     environment = "Terraform Demo"
//   }
// }
//
// # Create virtual machine
// resource "azurerm_virtual_machine" "myterraformvm" {
//   name                  = "consul-${random_id.name_suffix.hex}"
//   location              = "eastus"
//   resource_group_name   = azurerm_resource_group.myterraformgroup.name
//   network_interface_ids = [azurerm_network_interface.myterraformnic.id]
//   vm_size               = "Standard_DS1_v2"
//
//   storage_os_disk {
//     name              = "myOsDisk"
//     caching           = "ReadWrite"
//     create_option     = "FromImage"
//     managed_disk_type = "Premium_LRS"
//   }
//
//   storage_image_reference {
//     publisher = "Canonical"
//     offer     = "UbuntuServer"
//     sku       = "18.04.0-LTS"
//     version   = "latest"
//   }
//
//   os_profile_linux_config {
//     disable_password_authentication = true
//     ssh_keys {
//       path     = "/home/azureuser/.ssh/authorized_keys"
//       key_data = file("/data/.ssh/id_rsa.pub")
//     }
//   }
//
//   boot_diagnostics {
//     enabled     = "true"
//     storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
//   }
//
//   os_profile {
//     computer_name  = "consul-${random_id.name_suffix.hex}"
//     admin_username = "azureuser"
//     custom_data    = file("/vagrant/consul-service-mesh/terraform/startup_script")
//   }
//
//   tags = {
//     environment = "Terraform Demo"
//   }
//
// }
//
// # https://www.terraform.io/docs/providers/azurerm/d/public_ip.html
// data "azurerm_public_ip" "myterraformpublicip" {
//   name                = "${azurerm_public_ip.myterraformpublicip.name}"
//   resource_group_name = "${azurerm_virtual_machine.myterraformvm.resource_group_name}"
// }
//
// output "public_ip_address" {
//   value = "${data.azurerm_public_ip.myterraformpublicip.ip_address}"
// }
//
// output "azurerm_resource_group_myterraformgroup_name" {
//   value = "${azurerm_resource_group.myterraformgroup.name}"
// }
//
// output "ssh" {
//   value = "ssh azureuser@${data.azurerm_public_ip.myterraformpublicip.ip_address}"
// }
