# CodeCommit
variable "repository_name" {
  description = "The name of the CodeCommit repository."
  type        = string
}

variable "description" {
  description = "A description of the CodeCommit repository."
  type        = string
  default     = ""
}

variable "default_branch" {
  description = "The name of the default repository branch"
  type        = string
  default     = "main"
}

# IAM Group
variable "group_name" {
  description = "The name of the Iam Group"
  type        = string
}

# IAM Users
variable "user_name" {
  description = "The name of the IAM User."
  type        = list(string)
  default     = []
}

variable "path" {
  type        = string
  description = "The path of the IAM user"
}

variable "force_destroy" {
  type        = bool
  description = "Whether to destroy the IAM user when the module is destroyed"
}

# Tags
variable "tags" {
  type        = string
  description = "Additional tags for AWS resources"
}
