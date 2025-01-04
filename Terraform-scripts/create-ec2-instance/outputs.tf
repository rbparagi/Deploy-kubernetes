output "k8s_master_nodes" {
  value = [for instance in aws_instance.master_nodes : {
    Name      = instance.tags.Name
    PrivateIP = instance.private_ip
    PublicIP  = instance.public_ip
    Hostname  = instance.public_dns
  }]
}

output "k8s_worker_nodes" {
  value = [for instance in aws_instance.worker_nodes : {
    Name      = instance.tags.Name
    PrivateIP = instance.private_ip
    PublicIP  = instance.public_ip
    Hostname  = instance.public_dns
  }]
}
