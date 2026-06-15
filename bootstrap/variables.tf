variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "github_owner" {
  type    = string
  default = "NicolasAndresCalvo"
}

variable "state_bucket" {
  type    = string
  default = "nicolasandrescalvo-tfstate"
}

variable "lock_table" {
  type    = string
  default = "terraform-locks"
}

variable "site_bucket" {
  description = "The site bucket the web deploy role may write to."
  type        = string
  default     = "nicolasandrescalvo-portfolio"
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "portfolio"
    ManagedBy = "terraform-bootstrap"
  }
}
