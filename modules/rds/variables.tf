variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance (in gigabytes)"
}

variable "engine" {
  description = "The name of the database engine to be used for the RDS instance"
}

variable "engine_version" {
  description = "The version number of the database engine to be used for the RDS instance"
}

variable "instance_class" {
  description = "The instance class to be used for the RDS instance"
}

variable "db_name" {
  description = "The name of the database to be created on the RDS instance"
}

variable "db_username" {
  description = "The username for the master user of the RDS instance"
}

variable "db_password" {
  description = "The password for the master user of the RDS instance"
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group to associate with the RDS instance"
}

variable "security_group_id" {
  description = "Security group ID for the RDS instance"
}
