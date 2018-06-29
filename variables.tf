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

variable "count" {
  type        = "string"
  description = "Number of ec2 instances"
  default     = 1
}

variable "user_data" {
  type        = "string"
  description = "Provider User Data to EC2 Instance"
  default     = "${path.module}/userdata.sh"
}
