variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["eu-west-1a"]
}

variable "assume_role_principals" {
  description = "AWS principals allowed to assume the IAM role"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name for SSH access (leave empty to skip)"
  type        = string
  default     = ""
}
