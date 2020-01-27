resource "aws_db_instance" "main" {
  identifier = var.name

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine                = local.engine
  engine_version        = local.engine_version
  parameter_group_name  = aws_db_parameter_group.main.name

  db_subnet_group_name   = aws_db_subnet_group.main.name
  multi_az               = var.multi_az
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]

  name     = var.db_name
  username = var.username
  password = var.password

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  backup_window           = "17:00-18:00"
  backup_retention_period = 7
  maintenance_window      = "sun:18:00-sun:19:00"
  skip_final_snapshot     = true

  tags = merge(var.common_tags, { Name = format("%s-db", var.name) })
}

resource "aws_ssm_parameter" "db_dbname" {
  name        = "${var.name}-db-dbname"
  description = "Database dbname for ${var.name}"
  type        = "String"
  value       = var.db_name

  tags = merge(var.common_tags, { Name = format("%s-param-db-dbname", var.name) })
}

resource "aws_ssm_parameter" "db_user" {
  name        = "${var.name}-db-user"
  description = "Database user for ${var.name}"
  type        = "String"
  value       = var.username

  tags = merge(var.common_tags, { Name = format("%s-param-db-user", var.name) })
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.name}-db-password"
  description = "Database password for ${var.name}"
  type        = "SecureString"
  value       = var.password

  tags = merge(var.common_tags, { Name = format("%s-param-db-password", var.name) })
}
