/*output "public_ip" {
  value       = aws_instance.webserver_lt.public_ip
  description = "Public IP of the EC2 instance"
}
*/
output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}
