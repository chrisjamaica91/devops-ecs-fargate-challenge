output "ecs_task_execution_role_arn" {
  description = "ARN of ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "jenkins_role_arn" {
  description = "ARN of Jenkins IAM role"
  value       = aws_iam_role.jenkins_role.arn
}

output "jenkins_instance_profile_name" {
  description = "Name of Jenkins instance profile"
  value       = aws_iam_instance_profile.jenkins_profile.name
}