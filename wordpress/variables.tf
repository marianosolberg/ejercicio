variable "region" {
  type    = string
  default = "us-east-2"
}

variable "account_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "parent_zone_id" {
  type = string
}

variable "public_subnet_id" {
  type = list(string)
  description = "list of subnets"
  default = []
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssm_association_schedule_expression" {
  type    = string
  default = "cron(0 2 ? * SUN *)"
}

variable "ami" {
  default = "ami-0a040c35ca945058a"
}

variable "re_run_playbook" {
  type = string
}


variable "ids_sg" {
  type        = list(string)
  description = "List of SG IDs"
  default = []
}

variable "ids_sg_alb" {
  type        = list(string)
  description = "List of SG IDs"
  default = []
}

variable "white_list_ips" {
  type        = list(string)
  default = []
}

variable "domain_name" {
  description = "Nombre de dominio para asociar con el certificado SSL/TLS y el ALB"
  default     = ""
}