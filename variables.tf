variable "organization" {
  type        = "string"
  description = "TFE Organziation Name"
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  type = "string"
  description = "Environment Name"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "private_subnet" {
  default = ""
}

variable "subnet" {
  default = ""
}

variable "public_service_port" {
  default = "8000"
  description = "Port of Public Service"
  type = "string"
}

variable "service_cidr" {
  default = "0.0.0.0/0"
  type = "string"
  description = "CIDR Access"
}

variable "resource_tags" {
  type        = "map"
  description = "Resource Tags"
  default     = {
    env = "default"
    Owner = "Darnold"
    ttl = 24
    }
}

variable "instances" {
  type        = "string"
  description = "Number of ec2 instances"
  default     = -1
}

variable "user_data" {
  type        = "string"
  description = "Provider User Data to EC2 Instance"
  default     = "userdata.sh"
}


variable "instance_type" {
  type = "string"
  description = "EC2 Instance Type"
}

variable "ssh_cidr" {
  type = "string"
  default = "0.0.0.0/0"
  description = "SSH Access CIDR"
}
