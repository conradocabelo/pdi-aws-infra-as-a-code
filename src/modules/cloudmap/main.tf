resource "aws_service_discovery_private_dns_namespace" "dns_cloud_map" {
  name        = var.name_space
  description = "${var.name_space} cloud map"
  vpc         = var.vpc_id
}

output "private_namespace" {
  value = aws_service_discovery_private_dns_namespace.dns_cloud_map
}