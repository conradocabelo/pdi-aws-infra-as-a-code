resource "aws_security_group" "postgres_sg" {
  vpc_id      = var.vpc_id
  name        = "postgres_rds"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}