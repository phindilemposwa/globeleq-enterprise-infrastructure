variable "environment" {
  description = "The environment this IAM role is for (e.g. dev, qa, prod)"
  type        = string
}

variable "assume_role_principals" {
  description = "List of AWS principals allowed to assume this role"
  type        = list(string)
  default     = []
}

