variable "ecr_repositories" {
  type = list(string)
  default = [
    "checkout-api",
    "payment-api",
    "logistics-api",
  ]
}