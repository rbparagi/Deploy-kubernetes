variable "filename" {
    default = [
        "/Users/rbparagi/pets.txt",
        "/Users/rbparagi/animals.txt",
        "/Users/rbparagi/birds.txt",
        "/Users/rbparagi/fish.txt"
    ]
    type = set(string)
  
}

# for each loop work with  map, or set of strings

resource "local_file" "pets" {
    filename = each.value
    for_each = var.filename
    content = each.value

}

