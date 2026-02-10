variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of ECS task execution role"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of ECS task role"
  type        = string
}

variable "frontend_target_group_arn" {
  description = "ARN of frontend target group"
  type        = string
}

variable "backend_target_group_arn" {
  description = "ARN of backend target group"
  type        = string
}

variable "ecr_frontend_repository" {
  description = "ECR repository URI for frontend"
  type        = string
}

variable "ecr_backend_repository" {
  description = "ECR repository URI for backend"
  type        = string
}

variable "backend_api_url" {
  description = "Backend API URL for frontend to connect to"
  type        = string
}

variable "cpu" {
  description = "CPU units for ECS tasks (512 = 0.5 vCPU)"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory in MB for ECS tasks"
  type        = number
  default     = 1024
}

variable "min_tasks" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "desired_tasks" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "max_tasks" {
  description = "Maximum number of tasks"
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = 50
}