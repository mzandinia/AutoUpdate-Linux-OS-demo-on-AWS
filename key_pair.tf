resource "aws_key_pair" "ansibleloginkey" {
  key_name   = "demo-key"
  
  ## change following line if you are using different key pair
  public_key = file(pathexpand(var.ssh_public_keypair))
}
