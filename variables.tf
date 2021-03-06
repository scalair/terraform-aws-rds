####################
# VPC remote state #
####################
variable "vpc_bucket" {
  description = "Name of the bucket where vpc state is stored"
}

variable "vpc_state_key" {
  description = "Key where the state file of the VPC is stored"
}

variable "vpc_state_region" {
  description = "Region where the state file of the VPC is stored"
}

#######
# RDS #
#######
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "vault_generic_secret_rds_credentials_path" {
  description = "Hashicorp Vault path to retrieve master 'username' and 'password'"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "engine" {
  description = "The database engine to use"
  type        = string
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "major_engine_version" {
  description = "The major engine version to use"
  type        = string
}

variable "family" {
  description = "The family to use for parameter group"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "allowed_public_ips" {
  description = "List of public IPs/CIDR blocks that should be allowed access to RDS"
  type        = list(string)
  default     = []
}

# DB subnet group
variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

# DB parameter group
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "security_group_name" {
  description = "Name of security group associated to the RDS instance"
  type        = string
  default     = "rds_sg"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "dns_alias" {
  description = "Route 53 alias"
  type        = string
  default     = ""
}

variable "dns_ttl" {
  description = "Route 53 TTL"
  type        = string
  default     = "300"
}

variable "route_53_zone_id" {
  description = "Route 53 zone ID"
  type        = string
  default     = ""
}