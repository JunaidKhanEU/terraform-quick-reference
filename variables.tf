
variable "aws_region" {
  type        = string
  description = "AWS Region where resources reside"
  default     = "eu-west-1"
}

variable "instance_type" {
  type        = map(string)
  description = "EC2 instance type"
  default = {
    "dev" : "t3.micro",
    "prod" : "t3.large"
  }
}

variable "instance_names" {
  type        = list(string)
  description = "Names for instances"
  default     = ["demo version 1", "demo version 2"]
}

