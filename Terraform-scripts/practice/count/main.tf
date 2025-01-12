variable "filename" {
    default = [
        "/Users/rbparagi/pets.txt",
        "/Users/rbparagi/animals.txt",
        "/Users/rbparagi/birds.txt",
        "/Users/rbparagi/fish.txt"
    ]
  
}

resource "local_file" "pets" {
    filename = var.filename[count.index]
    count = length(var.filename)
    content = var.filename[count.index]
    

}