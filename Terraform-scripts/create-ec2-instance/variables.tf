# General Configurations
variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0219bfb6c89d10de5"
}

variable "vpc_id" {
  default = "vpc-0daba923f341202ed"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-0c0691ae1b03becd1", "subnet-05c4be2d2d1d50da9"]
}

variable "key_pair" {
  default = "ravi-personal-mac"
}

variable "volume_size" {
  default = 30
}

variable "volume_type" {
  default = "gp2"
}

# Kubernetes Cluster Configurations
variable "master_instance_type" {
  #default = "t3.large"
  default = "t2.micro"
}

variable "worker_instance_type" {
  default = "t2.large"
}

variable "master_node_count" {
  default = 1
}

variable "worker_node_count" {
  default = 0
}
