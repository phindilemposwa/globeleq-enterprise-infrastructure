variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "globeleq"
}

variable "bronze_bucket_name" {
  description = "Name of the bronze S3 bucket for Glue crawlers"
  type        = string
  default     = ""
}

variable "athena_output_bucket" {
  description = "S3 bucket for Athena query results"
  type        = string
  default     = ""
}
