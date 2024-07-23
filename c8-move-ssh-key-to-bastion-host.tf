# create a null resource for provisioners
resource "null_resource" "name" {
  depends_on = [azurerm_linux_virtual_machine.bastion_host_linuxvm]
  # connection block for provisioners to access and connect to azure vm instance
  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.bastion_host_linuxvm.public_ip_address
    user        = azurerm_linux_virtual_machine.bastion_host_linuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }

  # file provisioner: copies terraform-azure.pem file to /tmp/terraform-azure.pem on bastion host
  provisioner "file" {
    source      = "ssh-keys/terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"
  }

  # remote-exec provisioner: used to remotely execute commands on bastion host to change permmisions of terraform-azure.pem file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-azure.pem"
    ]
  }
}

# createion time provsioners: by default they are created during resource creations (terraform apply)
# destroy time provisioners: executed during "terraform destroy" command (when = destroy)