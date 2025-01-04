provider "aws" {
  region = var.aws_region
}

# Security Group for Kubernetes - Allow All Traffic
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Security Group for Kubernetes Cluster (Allow All Traffic)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow All Incoming Traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow All Outgoing Traffic
  }

  tags = {
    Name = "k8s-sg"
  }
}

# Master Nodes
resource "aws_instance" "master_nodes" {
  count                       = var.master_node_count
  ami                         = var.ami_id
  instance_type               = var.master_instance_type
  key_name                    = var.key_pair
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname k8s-master-${count.index + 1}
              echo "k8s-master-${count.index + 1}" > /etc/hostname
              echo "127.0.0.1 $(hostname)" >> /etc/hosts
              reboot
              EOF

  tags = {
    Name = "k8s-master-${count.index + 1}"
    Role = "master"
  }
}

# Worker Nodes
resource "aws_instance" "worker_nodes" {
  count                       = var.worker_node_count
  ami                         = var.ami_id
  instance_type               = var.worker_instance_type
  key_name                    = var.key_pair
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname k8s-worker-${count.index + 1}
              echo "k8s-worker-${count.index + 1}" > /etc/hostname
              echo "127.0.0.1 $(hostname)" >> /etc/hosts
              reboot
              EOF

  tags = {
    Name = "k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}

# Output Instance Details
output "k8s_instances" {
  value = concat(
    [
      for instance in aws_instance.master_nodes :
      {
        Name      = instance.tags.Name
        PrivateIP = instance.private_ip
        PublicIP  = instance.public_ip
        Hostname  = instance.public_dns
      }
    ],
    [
      for instance in aws_instance.worker_nodes :
      {
        Name      = instance.tags.Name
        PrivateIP = instance.private_ip
        PublicIP  = instance.public_ip
        Hostname  = instance.public_dns
      }
    ]
  )
}
