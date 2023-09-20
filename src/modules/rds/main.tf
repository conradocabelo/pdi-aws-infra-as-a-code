resource "aws_db_subnet_group" "subnet_group" {
  name       = "rds-subnet-groups"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres_rds" {
  identifier             = "mysql-rds"
  name                   = "mysql_server"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  username               = "pdiadm"
  password               = var.password_db
}