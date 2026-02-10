output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP address"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_public_dns" {
  description = "Jenkins public DNS name"
  value       = aws_instance.jenkins.public_dns
}

output "jenkins_url" {
  description = "Jenkins web UI URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}