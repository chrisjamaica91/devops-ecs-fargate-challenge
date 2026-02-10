variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ecr_backend_repository_arn" {
  description = "ARN of backend ECR repository"
  type        = string
  default     = "arn:aws:ecr:us-east-1:737026300147:repository/devops-challenge/backend"
}

variable "ecr_frontend_repository_arn" {
  description = "ARN of frontend ECR repository"
  type        = string
  default     = "arn:aws:ecr:us-east-1:737026300147:repository/devops-challenge/frontend"
}