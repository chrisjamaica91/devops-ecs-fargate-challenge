# Networking Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "frontend_url" {
  description = "Frontend application URL"
  value       = "http://${module.alb.alb_dns_name}"
}

output "backend_api_url" {
  description = "Backend API URL"
  value       = "http://${module.alb.alb_dns_name}/api"
}

# Jenkins Outputs
output "jenkins_url" {
  description = "Jenkins web UI URL"
  value       = module.jenkins.jenkins_url
}

output "jenkins_public_ip" {
  description = "Jenkins public IP address"
  value       = module.jenkins.jenkins_public_ip
}

output "jenkins_initial_password_command" {
  description = "Command to retrieve Jenkins initial admin password"
  value       = "ssh to Jenkins instance and run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "backend_service_name" {
  description = "Backend ECS service name"
  value       = module.ecs.backend_service_name
}

output "frontend_service_name" {
  description = "Frontend ECS service name"
  value       = module.ecs.frontend_service_name
}

# ECR Outputs
output "ecr_backend_repository" {
  description = "Backend ECR repository URI"
  value       = var.ecr_backend_repository
}

output "ecr_frontend_repository" {
  description = "Frontend ECR repository URI"
  value       = var.ecr_frontend_repository
}