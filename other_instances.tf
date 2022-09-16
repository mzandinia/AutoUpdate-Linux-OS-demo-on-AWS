resource "aws_instance" "amazon-1" {
  ami           = data.aws_ami.amz-linux2.id
  instance_type = var.instance_types[0]
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.private-sub.id
  user_data = file("user-data-other-instance.sh")

  tags = {
    Name = "amazon-1"
  }
}

resource "aws_instance" "amazon-2" {
  ami           = data.aws_ami.amz-linux2.id
  instance_type = var.instance_types[0]
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.public-sub.id
  user_data = file("user-data-other-instance.sh")

  tags = {
    Name = "amazon-2"
  }
}

resource "aws_instance" "debian" {
  ami           = data.aws_ami.debian.id
  instance_type = var.instance_types[0]
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.public-sub.id

  user_data = file("user-data-other-instance.sh")

  tags = {
    Name = "debian"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_types[0]
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.public-sub.id

  user_data = file("user-data-other-instance.sh")

  tags = {
    Name = "ubuntu"
  }
}

resource "aws_spot_instance_request" "splunk" {
  ami           = data.aws_ami.splunk.id
  instance_type = var.instance_types[2]
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 20
    volume_type = "gp3"
    iops = 3000
    throughput = 125
    delete_on_termination = true
  }
  # spot_price    = "0.05"
  wait_for_fulfillment = true
  instance_interruption_behavior = "stop"
  availability_zone = data.aws_availability_zones.listOfAZ.names[0]
  key_name = aws_key_pair.ansibleloginkey.key_name
  subnet_id = aws_subnet.public-sub.id
  vpc_security_group_ids = [ aws_security_group.allowingssh.id,
                             aws_security_group.splunksg.id ]

  user_data = file("user-data-other-instance.sh")

  tags = {
    Name = "Splunk"
  }
}
