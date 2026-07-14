variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to launch instances in"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for instance placement"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type (stick to free tier: t2.micro)"
  type        = string
  default     = "t2.micro"
}
