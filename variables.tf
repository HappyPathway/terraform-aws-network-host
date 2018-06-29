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
