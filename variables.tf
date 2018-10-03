variable "organization" {
  type        = "string"
  description = "TFE Organziation Name"
}

variable "network_ws" {
  type        = "string"
  description = "TFE Network Workspace"
}

variable "resource_tags" {
  type        = "map"
  description = "Resource Tags"
  default     = {}
}

variable "public_instances" {
  type        = "string"
  description = "Number of Public ec2 instances"
  default     = -1
}

variable "private_instances" {
  type        = "string"
  description = "Number of Private ec2 instances"
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
