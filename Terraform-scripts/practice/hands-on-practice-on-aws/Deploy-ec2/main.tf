resource "aws_instance" "web-instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_pair
    associate_public_ip_address = var.enable_public_ip
    subnet_id = var.subnet_ids[0]
    #security_groups = var.security_group_ids[0]
    vpc_security_group_ids = var.security_group_ids
    count = var.instance_count

    user_data = <<-EOF
              #!/bin/bash
              sodo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Welcome to Apache Server - Provisioned by Terraform `hostname`</h1>" > /var/www/html/index.html
              EOF

    tags = {
      "Name" = "AWS-Web-Instance-${count.index + 1}"
      "Environment" = "Developmemt"
    }

    
  
}