variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CDIR de enderecos publicos"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CDIR de enderecos privados"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zone" {
  type        = list(string)
  description = "Zonas de disponibilidade"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}