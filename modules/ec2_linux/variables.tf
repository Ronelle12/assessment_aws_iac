variable "default_tags" {
  description = "Set of default tags to apply to all component supporting tags. Refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging#propagating-tags-to-all-resources"
  type        = map(string)
}

variable "ec2_name" {
  description = "EC2 instance name"
  type        = string
}


variable "ami" {
  description = "The ami for this instance"
  type        = string
}

variable "instance_type" {
  description = "Instance size"
  type        = string
}

variable "subnet_id" {
  description = "Subnet"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = number
}

variable "ebs_volumes" {
  description = "EBS volume"
  default = []
  type        = list(object({
    name = string
    volume_size = number
  }))
}

variable custom_security_group_ids {
  description = "A list of customer security groups to add to the EC2 instance."
  type = list(string)
  default = []
}

variable custom_policies_arns {
  description = "A list of custom IAM policies to be attached ot the EC2 instance."
  type = list(string)
  default = []
}

variable "security_group_rules_cidr_blocks" {
  description = "A list of security group rules to apply to the EC2 instance allowing CIDR blocks."
  type = map(object({
    description = string
    type        = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "user_data_base64" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = ""
}

variable "join_domain_role" {
  description = "role that is required for domain join automation"
  type = list(string)
  default = []
}

variable "public_key" {
  description = "public key to add to server for ssh auth"
  type = string
  default = ""
}