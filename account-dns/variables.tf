variable "name" {
  type        = string
  default     = ""
}

variable "buckettoprod" {
  type        = bool
  default     = false
}

variable "account_id" {
  type        = string
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}