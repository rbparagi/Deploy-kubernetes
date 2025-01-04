variable "prefix" {
  default = ["Mr", "Mrs", "Miss", "Ms", "Dr"]
  type = list(string)
  
}

# Map variable

variable "file-content" {
  default = {
    "statement1" = "we love pets"
    "statement2" = "we love animals"
  }
}

variable kitty {
  type = tuple([string, number, bool])
  default = ["cat", 1, true]

}