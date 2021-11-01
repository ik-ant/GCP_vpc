#=================================VPC================================
variable "gcp_vpc_name" {
  description = "The name of created vpc"
  type = string
  default = "vpc"
}


variable "auto_create_subnetworks" {
  description = "It will create a subnet for each region automatically across the across CIDR-block range, if it is <true> "
  type = bool
  default = false
}

variable "routing_mode" {
  description = "The network routing mode"
  type = string
  default = "REGIONAL"
}

variable "delete_default_routes_on_create" {
  type = bool
  default = true
}


#============================SUBNETS==================================
variable "region" {
  description = "The region where resource will be created"
  type = string
  default = "us-central1"
}

variable "subnets" {
  type = list(map(string))
}




#===========================FIREWALL_RULES============================

#-----------------------PRESENTATION FIREWALL-------------------------
variable "presentation_tags" {
  type = list(string)
  default = [ "" ]
}

variable "presentation_protocol" {
  type = string
  default = "tcp"
}

variable "presentation_ports" {
  type = list(string)
  default = [ "" ]
}

#----------------------APPLICATION FIREWALL---------------------------
variable "app_firewall_ingress_range" {
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "app_tags" {
  type = list(string)
  default = [ "" ]
}

variable "app_protocol" {
  type = string
  default = ""
}

variable "app_ports" {
  type = list(string)
  default = [ "" ]
}


#--------------------DATABASE FIREWALL-------------------------------
variable "db_firewall_ingress_range" {
  type = list(string)
  default = [ "10.0.2.0/24" ]
}

variable "db_tags" {
  type = list(string)
  default = [""]
}

variable "db_protocol" {
  type = string
  default = ""
}

variable "db_ports" {
  type = list(string)
  default = [""]
}

