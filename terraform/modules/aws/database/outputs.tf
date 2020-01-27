output "db_instance" {
  value = aws_db_instance.main
}

output "ssm_parameter_db_dbname" {
  value = aws_ssm_parameter.db_dbname
}

output "ssm_parameter_db_user" {
  value = aws_ssm_parameter.db_user
}

output "ssm_parameter_db_password" {
  value = aws_ssm_parameter.db_password
}
