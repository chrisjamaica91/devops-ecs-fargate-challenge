variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devops-challenge"
}

variable "ecr_backend_repository" {
  description = "ECR repository URI for backend"
  type        = string
  default     = "737026300147.dkr.ecr.us-east-1.amazonaws.com/devops-challenge/backend"
}

variable "ecr_frontend_repository" {
  description = "ECR repository URI for frontend"
  type        = string
  default     = "737026300147.dkr.ecr.us-east-1.amazonaws.com/devops-challenge/frontend"
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "t3.medium"
}

variable "ecs_cpu" {
  description = "CPU units for ECS tasks (512 = 0.5 vCPU)"
  type        = number
  default     = 512
}

variable "ecs_memory" {
  description = "Memory in MB for ECS tasks"
  type        = number
  default     = 1024
}

variable "ecs_min_tasks" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_max_tasks" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4
}

variable "ecs_desired_tasks" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "autoscaling_cpu_target" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = 50
}