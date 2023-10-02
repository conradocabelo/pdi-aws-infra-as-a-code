variable "ecs_cluster_name" {
  type    = string
  default = "checkout-ms-pool"
}
variable "public_subnets" {}
variable "private_namespace" {}
variable "vpc_id" {}

variable "ecs_tasks" {
  type = list(object({
    family          = string
    cpu             = number
    memory          = number
    image_name      = string
    tag_image       = string
    container_name  = string
    type            = string
    number_tasks    = number
    enviroment_file = string
  }))
  default = [
    {
      family          = "checkout-api"
      cpu             = 512
      memory          = 1024
      image_name      = "checkout-api"
      tag_image       = "latest"
      container_name  = "ms-checkout-api"
      type            = "dash"
      number_tasks    = 1
      enviroment_file = "definition-tasks/checkout-api.json"
    },
    {
      family          = "payment-api"
      cpu             = 512
      memory          = 1024
      image_name      = "payment-api"
      tag_image       = "latest"
      container_name  = "ms-payment-api"
      type            = "dash"
      number_tasks    = 1
      enviroment_file = "definition-tasks/payment-api.json"
    },
    {
      family          = "logistics-api"
      cpu             = 512
      memory          = 1024
      image_name      = "logistics-api"
      tag_image       = "latest"
      container_name  = "ms-logistics-api"
      type            = "dash"
      number_tasks    = 1
      enviroment_file = "definition-tasks/logistics-api.json"
    }
  ]
}