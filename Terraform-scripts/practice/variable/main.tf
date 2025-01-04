resource "random_pet" "my-pet" {
    prefix = var.prefix[0]
}

resource "local_file" "my-file" {
    filename = "/Users/rbparagi/working_dir/Deploy-kubernetes/Terraform-scripts/practice/variable/pets.txt"
    content = var.file-content["statement2"]
 
}

resource "random_pet" "mypet" {
    prefix = var.kitty[0]
  
}