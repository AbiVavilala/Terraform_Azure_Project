# Azure provider and source specified

terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
      }
    }
}

#Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a Resource group

resource "azurerm_resource_group" "Dev_Environment" {
    name = "Dev_Environment"
    location = var.Azure_location
    tags = {
      environment = "dev"
    }
  
}
 
#Create Virtual network 

resource "azurerm_virtual_network" "dev-vn" {
  
  name = "dev-vn"
  resource_group_name = var.resource_group_name
  location =  var.Azure_location
  address_space = ["10.123.0.0/16"]
  
  tags = {
    environment = "dev"
  }
  }

# create a subnet

resource "azurerm_subnet" "dev_subnet" {
  name = "dev_subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtualnetwork_name
  address_prefixes = ["10.123.1.0/24"]
}

#create security group

resource "azurerm_network_security_group" "dev_sg" {
  name = "dev_sg"
  location = var.Azure_location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "dev_sg"
  }
}
#security group rule

resource "azurerm_network_security_rule" "dev_sg_rule" {
  name                        = "dev_sg_rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         =  var.resource_group_name
  network_security_group_name =  azurerm_network_security_group.dev_sg.name
}


#subnet security group association 
resource "azurerm_subnet_network_security_group_association" "dev_subnet_sg_association" {
  subnet_id = azurerm_subnet.dev_subnet.id
  network_security_group_id = azurerm_network_security_group.dev_sg.id
}