variable "region" {
  default = "ap-south-1"
  
}

variable "ami_id" {
  default = "ami-0fd05997b4dff7aac"
  
}

variable "vpc_id" {
  default = "vpc-02a41663f5bbf8a83"
  
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-046aa97dde32948a3", "subnet-0d87453cb0a2193fd"]
  
}

variable "key_pair" {
  default = "ravi-personal-mac"
  
}

variable "enable_public_ip" {
  default = true
  
}

variable "instance_type" {
  default = "t2.micro"
  
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-092d991a1f9a3c02b", "sg-06a9f0959934630b3"]
  
}

variable "instance_count" {
  default = 1
  type = number
  description = "Number of instances to be created"
  
}
