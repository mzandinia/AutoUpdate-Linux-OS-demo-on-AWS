# Demonstration for auto-update Linux OS on AWS

## Description
By running this repo, you can see how "Auto-update Linux OS" works.

It simulates all the processes, and you can see the final dashboard on Splunk after the update process runs on all servers.

`Because it's just a demonstration, I've constructed everything you need to see the final dashboard perfectly. So after viewing the final result, you can simply destroy all the resources.`

## Getting Started

### Resources
  - 1x ec2 instance for Ansible controller. (Debian ami)
  - 1x ec2 instance for Splunk. (Splunk ami)
  - 4x ec2 instances for testing the update process. (2 Amazon Linux, 1 Debian, 1 Ubuntu)
  - 1x vpc
  - 2x subnets
  - 1x internet gateway
  - 2x route tables
  - 2x route table association
  - 3x security groups

### Tasks that are performed on the Ansible node during the boot process

  - Installing pip
  - Installing Ansible by using pip
  - Set the Ansible execution folder path to the PATH variable in bashrc file 
  - Cloning the AutoUpdate-Linux-OS repository

### Tasks that are performed on the testing nodes during the boot process

  - Creating the demoautoupdate user
  - Set the user password
  - Configure the user to run sudo password less
  - Config the ssh service to accept password authentication

### Tasks that are performed on the Ansible node after ensuring that all nodes are up

  - Creating config and inventory files on itself
  - Executing the auto-update playbook

### Variables

  - region: the default sets to us-east-1
  - instance types: the default for Splunk is set to "c5.large" and the others "t2.micro"
  - ssh_public_keypair: configured to use your own ssh keypair. You must modify the default value if your keypair is located on another path.
  - ssh_private_keypair: like ssh_public_keypair
  - vpc_cidr: The cidr block of the VPC
  - public_subnet_cidr: the public subnet cidr block
  - private_subnet_cidr: the private subnet cidr block

**Note: I intentionally used two subnets to demonstrate a cache update failure.**

### Datasources:

  - aws_ami: because the AMI id is different in the various regions, I use the datasource in order to get the right AMI id.
  - aws_security_groups: get the default security group id 
  - aws_availability_zones: list of AZ

## How to use this repository

### 1. Install Terraform

[Download](https://www.terraform.io/downloads.html) and [Install](https://learn.hashicorp.com/tutorials/terraform/install-cli) Terraform, If you didn't.

### 2. Config AWS credentials

Use [AWS Authentication and Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for more information.

### 3. Subscribe Ubuntu and Splunk AMI's

Please subscribe below AMI's to avoid getting errors during "Terraform apply"

[Ubuntu 22.04 LTS - Jammy](https://aws.amazon.com/marketplace/pp/prodview-f2if34z3a4e3i?)

[Minimal Ubuntu 22.04 LTS - Jammy](https://aws.amazon.com/marketplace/pp/prodview-o5bowpuwmx3ng?)

[Splunk Enterprise](https://aws.amazon.com/marketplace/pp/prodview-l6oos72bsyaks?)
### 4. SSH Keys

If you have keypairs, you can use it (ensure that the path is correctly set in `variables.tf`); otherwise create new ssh keys.

```shell
$ ssh-keygen
```

  - ***Warning**: Please remember to not to overwrite the existing ssh key pair files; use a new file name if you want to keep the old keys.*

### 5. Clone the Repository

```shell
$ git clone https://github.com/mzandinia/AutoUpdate-Linux-OS-demo-on-AWS.git
$ cd AutoUpdate-Linux-OS-demo-on-AWS
$ terraform init
$ terraform plan
$ terraform apply
.
.
.
Outputs:
splunk-login-address = http://<splunk public IP>:8000
splunk-login-user-pass = user: admin, pass=SPLUNK-<splunk instance id>
```

- ***Imortant**: If you get the subscription error, just go to the URL provided by Terraform and subscribe the instance. Then rerun the `terraform apply`*

### **After all this, go to the URL and login with the username and password that Terraform prints into the output. Then on the left menu click on the `Search and Reporting` and see the dashboard.**
