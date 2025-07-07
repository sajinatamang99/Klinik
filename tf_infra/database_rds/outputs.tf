# rds for web server
output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
# rds for sonarqube
output "sonar_db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "sonar_db_username" {
  value = var.db_username
}

output "sonar_db_password" {
  value = var.db_password
}
