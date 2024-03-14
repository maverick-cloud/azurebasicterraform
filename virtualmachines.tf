resource "azurerm_linux_virtual_machine" "R11_EUSPRODWEBVM1" {
  admin_username                  = "sri"
  disable_password_authentication = false
  admin_password                  = "Welcome@1234"
  location                        = azurerm_resource_group.R1_EUSPRODRG.location
  name                            = "EUSPRODWEBVM1"
  computer_name                   = "EUSPRODWEBVM1"
  network_interface_ids = [azurerm_network_interface.R6_EUSPRODWEBVM1-NIC.id
  ]
  resource_group_name = azurerm_resource_group.R1_EUSPRODRG.name
  size                = "Standard_B1s"
  os_disk {
    name                 = "EUSPRODWEBVM1_OSDISK"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  #custom_data = filebase64("webserver.sh")
  tags = {
    session = "2"
    test = "basicloadbalancer"
  }
}