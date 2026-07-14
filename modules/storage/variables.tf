variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "project" {
  description = "Project name used as bucket prefix"
  type        = string
  default     = "globeleq"
}
