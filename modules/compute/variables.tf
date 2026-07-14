variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to launch instances in"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for instance placement"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (stick to free tier: t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access (leave empty to skip)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
