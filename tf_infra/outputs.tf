output "jenkins_public_ip" {
  description = "Public IP of Jenkins server"
  value       = module.jenkins.jenkins_public_ip
}

output "rds_endpoint" {
  value = module.database_rds.db_endpoint
}

output "monitoring_instance_public_ip" {
  description = "Public IP of Prometheus monitoring server"
  value       = module.prometheus.monitoring_instance_public_ip
}

output "sonar_public_ip" {
  value = module.sonarqube.sonar_public_ip
}

output "sonar_db_endpoint" {
  value = module.database_rds.sonar_db_endpoint
}
