
variable "common_tags" {
  type        = map(string)
  description = "Common Tags"
  default = {
    Environment = "dev"
    Version     = ".1"
    Owner       = "terracloudrlm.com"
  }
}

