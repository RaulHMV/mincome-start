variable "aws_region" {
  description = "AWS region where the Mincome database service is deployed."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC hosting the private database subnets."
  type        = string
}

variable "private_subnet_ids" {
  description = "At least two private subnet IDs in different Availability Zones."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Provide at least two private subnet IDs."
  }
}

variable "database_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to PostgreSQL port 5432."
  type        = list(string)
}

variable "database_name" {
  description = "Logical PostgreSQL database name."
  type        = string
  default     = "mincome"
}

variable "database_host" {
  description = "PostgreSQL endpoint used by the PostgreSQL provider to create the schema."
  type        = string
}

variable "database_port" {
  description = "PostgreSQL port."
  type        = number
  default     = 5432
}

variable "database_admin_username" {
  description = "RDS master username."
  type        = string
  sensitive   = true
}

variable "database_admin_password" {
  description = "RDS master password."
  type        = string
  sensitive   = true
}

variable "database_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "database_storage_gb" {
  description = "Allocated RDS storage in GiB."
  type        = number
  default     = 20
}
