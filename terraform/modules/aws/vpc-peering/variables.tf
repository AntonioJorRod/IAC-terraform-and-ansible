variable "requester_vpc_id" { type = string }
variable "accepter_vpc_id"  { type = string }
variable "requester_region" { type = string }
variable "accepter_region"  { type = string }
variable "tags" { 
  type = map(string) 
  default = {} 
}
