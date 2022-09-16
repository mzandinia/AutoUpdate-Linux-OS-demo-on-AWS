resource "aws_instance" "ansible" {
  ami           = data.aws_ami.debian.id
  instance_type = var.instance_types[0]
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.public-sub.id
  vpc_security_group_ids = [ aws_security_group.allowingssh.id, 
                             data.aws_security_groups.default.ids[0] ]

  user_data = file("user-data-ansible.sh")
  user_data_replace_on_change = true

  # create ansible config file and inventory, then execute the playbook to update other instances
  provisioner "remote-exec" {
    inline = [ "sleep 300",
      "echo '---' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo 'all:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '  hosts:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '    controller:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '      ansible_host: ${aws_instance.ansible.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '      ansible_connection: local' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '  children:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '    other:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '      hosts:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        amazon-1:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: ${aws_instance.amazon-1.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        amazon-2:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: ${aws_instance.amazon-2.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        debian:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: ${aws_instance.debian.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        ubuntu:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: ${aws_instance.ubuntu.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        splunk:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: ${aws_spot_instance_request.splunk.private_dns}' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        demo-unrechable:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '          ansible_host: demo-unrechable' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '      vars:' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        ansible_user: demoautoupdate' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        ansible_password: changeme' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        ansible_connection: ssh' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo '        ansible_ssh_extra_args: \"-o StrictHostKeyChecking=no -o PreferredAuthentications=password\"' >> /home/admin/AutoUpdate-Linux-OS/inventory.yml",
      "echo 'inventory = ./inventory.yml' >> /home/admin/AutoUpdate-Linux-OS/ansible.cfg",
      "echo 'remote_user = demoautoupdate' >> /home/admin/AutoUpdate-Linux-OS/ansible.cfg",
      "cd /home/admin/AutoUpdate-Linux-OS && ansible-playbook AutoUpdate_Linux.yml"   
    ]
    connection {
      type = "ssh"
      user = "admin"
      private_key = file(pathexpand(var.ssh_private_keypair))
      host = self.public_ip
      agent = false
    }
  }

  tags = {
    Name = "Ansible"
  }
}

