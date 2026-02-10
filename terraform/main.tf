# Networking Module
module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# Security Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  vpc_cidr     = module.networking.vpc_cidr
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name               = var.project_name
  environment                = var.environment
  ecr_backend_repository_arn = "arn:aws:ecr:${var.aws_region}:737026300147:repository/devops-challenge/backend"
  ecr_frontend_repository_arn = "arn:aws:ecr:${var.aws_region}:737026300147:repository/devops-challenge/frontend"
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  project_name               = var.project_name
  environment                = var.environment
  aws_region                 = var.aws_region
  vpc_id                     = module.networking.vpc_id
  private_subnet_ids         = module.networking.private_subnet_ids
  ecs_security_group_id      = module.security.ecs_tasks_security_group_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn          = module.iam.ecs_task_role_arn
  frontend_target_group_arn  = module.alb.frontend_target_group_arn
  backend_target_group_arn   = module.alb.backend_target_group_arn
  ecr_frontend_repository    = var.ecr_frontend_repository
  ecr_backend_repository     = var.ecr_backend_repository
  backend_api_url            = "http://${module.alb.alb_dns_name}/api"
  cpu                        = var.ecs_cpu
  memory                     = var.ecs_memory
  min_tasks                  = var.ecs_min_tasks
  desired_tasks              = var.ecs_desired_tasks
  max_tasks                  = var.ecs_max_tasks
  autoscaling_cpu_target     = var.autoscaling_cpu_target
}

# Jenkins Module
module "jenkins" {
  source = "./modules/jenkins"

  project_name                = var.project_name
  environment                 = var.environment
  vpc_id                      = module.networking.vpc_id
  public_subnet_ids           = module.networking.public_subnet_ids
  jenkins_security_group_id   = module.security.jenkins_security_group_id
  jenkins_instance_profile_name = module.iam.jenkins_instance_profile_name
  instance_type               = var.jenkins_instance_type
  key_name                    = "root" # Leave empty or add your key pair name
}