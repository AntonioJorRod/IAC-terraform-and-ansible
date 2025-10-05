variable "name" { type = string }
variable "description" { type = string }
variable "tags" { 
    type = map(string) 
    default = {} 
}

variable "vpc_map" {
  description = "Mapa con VPCs y sus subnets privadas"
  type = map(object({
    vpc_id             = string
    private_subnet_ids = list(string)
  }))
}
