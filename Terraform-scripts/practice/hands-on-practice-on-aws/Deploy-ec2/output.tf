output "instance_ip" {
    value = aws_instance.web-instance.public_ip
  
}

output "instance_id" {
    value = aws_instance.web-instance.id
}
