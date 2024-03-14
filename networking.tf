resource "azurerm_virtual_network" "R3_EUSPRODVNET1" {
  name                = "EUSPRODVNET1"
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  address_space       = ["10.10.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "R8_WEBSUBNET" {
  address_prefixes     = ["10.10.10.0/24"]
  name                 = "WEBSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

resource "azurerm_subnet" "R9_APPSUBNET" {
  address_prefixes     = ["10.10.20.0/24"]
  name                 = "APPSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

resource "azurerm_subnet" "R10_DBSUBNET" {
  address_prefixes     = ["10.10.30.0/24"]
  name                 = "DBSUBNET"
  resource_group_name  = azurerm_resource_group.R1_EUSPRODRG.name
  virtual_network_name = azurerm_virtual_network.R3_EUSPRODVNET1.name
}

resource "azurerm_network_security_group" "R4_EUSPRODNSG" {
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODNSG"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  security_rule {
    name                       = "allowsshhttp"
    access                     = "Allow"
    direction                  = "Inbound"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "R5_EUSPRODWEBVM1-PIP" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODWEBVM1-PIP"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
}

resource "azurerm_network_interface" "R6_EUSPRODWEBVM1-NIC" {
  location            = azurerm_resource_group.R1_EUSPRODRG.location
  name                = "EUSPRODWEBVM1-NIC"
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  ip_configuration {
    name                          = "EUSPRODWEBVM1-NIC-CONFIG"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.R8_WEBSUBNET.id
    public_ip_address_id          = azurerm_public_ip.R5_EUSPRODWEBVM1-PIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "R7_ASSOC1" {
  network_interface_id      = azurerm_network_interface.R6_EUSPRODWEBVM1-NIC.id
  network_security_group_id = azurerm_network_security_group.R4_EUSPRODNSG.id
}