variable "region" {
  description = "maps of regions"
  type        = map(string)

  default = {
    r1 = "us-east-1"
    r2 = "us-east-2"
    r3 = "us-west-1"
    r4 = "us-west-2"
    r5 = "eu-central-1"
  }
}

variable "instance_types" {
  description = "A list of instance types"
  type        = list
  default     = ["t2.micro", "t3.small", "c5.large", "c5.2xlarge"]
}

variable "ssh_public_keypair" {
  default = "~/.ssh/id_rsa.pub"
  #default = "~/.ssh/id_rsa_ansilble_lab.pub"
}

variable "ssh_private_keypair" {
  default = "~/.ssh/id_rsa"
  #default = "~/.ssh/id_rsa_ansilble_lab"
}

variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "PUBLIC SUBNET CIDR BLOCK"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_cidr" {
  description = "PRIVATE SUBNET CIDR BLOCK"
  type        = string
  default     = "10.0.20.0/24"
}
