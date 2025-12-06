# DB Subnet Group (requiere al menos 2 subnets en diferentes AZs)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project}-rds-subnet-group"
  subnet_ids = var.rds_subnet_ids

  tags = {
    Name        = "${var.project}-rds-subnet-group"
    Environment = var.environment
  }
}

# DB Parameter Group (optimizaciones MySQL)
resource "aws_db_parameter_group" "rds_params" {
  name   = "${var.project}-mysql-params"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  tags = {
    Name        = "${var.project}-mysql-params"
    Environment = var.environment
  }
}

# RDS MySQL Multi-AZ Instance
resource "aws_db_instance" "mysql" { //línea 39 kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
  identifier     = "${var.project}-mysql"
  engine         = "mysql"
  engine_version = var.engine_version

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  # Multi-AZ para alta disponibilidad
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  parameter_group_name   = aws_db_parameter_group.rds_params.name

  # Backups
  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  # Snapshots
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.project}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  copy_tags_to_snapshot     = true

  # Protección contra eliminación accidental
  deletion_protection = var.deletion_protection

  # Logs en CloudWatch
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  # Actualizaciones automáticas menores
  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.project}-mysql"
    Environment = var.environment
  }
}