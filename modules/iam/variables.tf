variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "assume_role_principals" {
  description = "List of AWS principals allowed to assume this role"
  type        = list(string)
  default     = []
}
