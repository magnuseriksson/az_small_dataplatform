variable "env" {
  description = "environment name , dev, stage, prod"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "The location for the resource group and all resources."
  type        = string
  default     = "northeurope"
}

variable "prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "myproject"
}
