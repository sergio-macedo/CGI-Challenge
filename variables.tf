variable "ssh_public_key" {
  description = "SSH public key for EC2 instance"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSEOBFk3wKyg9NmKJkRgS/jNMK0Rzz9H3dXcNOKPV6e0I5k/f8MXpOHcsqHwz3kMIX3fp/WBkANMQSQgOeRXSWsxuFdso1LMedx+7jjqGRBdKCFtkr/vMhoFUpVPuq/hTyDDQHQAbvw5gzxL8QSa12mlH0liKA5311udavRwUFAiilgq0bdpJ59Gw2hknpUU//WFZh4RnzCEaX3pKzcQQ1wZK9gejUVqhkUkd1+UY3yap/ESmBLuAGryl17wrBBT2/hRgHSwwhGGx25C5iCoxe9F4J0oTOaJmKDn5dETLL/oFSABPp4ryR5ZbGlTec7Rza1kiHYDwiAFQ34f3dI/3ya/5edGEHE7ciZaxDEJIWNHxOkweku2MSz7TRhUEkDeAU6bORluaP26Q7H8Egi+WOIoefNAYiH4Viga40cYlSL0lU2QAI8puw0glQYIUQLK2VhjS+SLTosDUe4jnbBBXFtu2Dk2K4SmGZz/yN1tSmpuAm+O/tVoVF4aaWnDYzpBc= sergi@LAPTOP-QAF5LOGO"
}

variable "aws_region" {
  description = "the region of our deployment"
  type        = string
  default     = "eu-central-1"

}


#vpc module variables

variable "cidr_block" {
  type        = string
  description = "CIDR of the vpc"
  default = "10.0.0.0/16"
}

variable "project_name" {
  type        = string
  description = "Project name to be used to name the resources (Name tag)"
  default = "CGI-Dev-Challenge"
}

# variable "tags" {
#   type        = map(any)
#   description = "project tags"

# }

variable "azs" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]  # Update with desired AZs
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]  # Corresponding CIDRs for the subnets
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]  # Corresponding CIDRs for the subnets
}


#variables from ecs


variable "region" {
  default = "eu-central-1"
}

variable "app_name" {
  default = "CGI-Nginx"
}

variable "desired_count" {
  default = 1
}

variable "cpu" {
  default = "512"
}

variable "memory" {
  default = "1024"
}