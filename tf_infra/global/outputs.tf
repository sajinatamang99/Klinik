output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

output "security_group_ids" {
  value = {
    webserver = aws_security_group.webserver_sg.id
    jenkins   = aws_security_group.jenkins_sg.id
    sonarqube = aws_security_group.sonarqube_sg.id
    # prometheus= aws_security_group.prometheus_sg.id
    database = aws_security_group.rds_sg.id
  }
}

output "webserver_sg_id" {
  value = aws_security_group.webserver_sg.id
}
output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}
