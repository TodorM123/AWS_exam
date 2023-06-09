variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "eu-west-1"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "image_name" {
  default     = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
  type        = string
  description = "Amazon linux image name"
}

variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "172.16.0.0/16"
}

variable "vpc_cidr_block_for_public1" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "172.16.1.0/24"
}

variable "vpc_cidr_block_for_public2" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "172.16.3.0/24"
}

variable "vpc_cidr_block_for_private1" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "172.16.4.0/24"
}

variable "vpc_cidr_block_for_private2" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "172.16.5.0/24"
}

variable "policy_arn_Cloud_Watch" {
  default = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

variable "instance_data" {
  default = {
    name-prefix = "Instanciika"
    image_id = "ami-0649a986224ded9da"
    instance_type = "t2.micro"
  }
}

