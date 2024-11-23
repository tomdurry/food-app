module "network" {
  source                    = "../../modules/network"
  project                   = var.project
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  enable_dns_support        = var.enable_dns_support
  enable_dns_hostnames      = var.enable_dns_hostnames
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  availability_zones        = var.availability_zones
  service_endpoints         = var.service_endpoints
  public_subnet_count       = var.public_subnet_count
  private_subnet_count      = var.private_subnet_count
  nat_gateway_count         = var.nat_gateway_count
  public_route_table_count  = var.public_route_table_count
  private_route_table_count = var.private_route_table_count
  map_public_ip_on_launch   = var.map_public_ip_on_launch
  internet_route_cidr       = var.internet_route_cidr
  http_port                 = var.http_port
  ingress_protocol          = var.ingress_protocol
  ingress_cidr_blocks       = var.ingress_cidr_blocks
  egress_from_port          = var.egress_from_port
  egress_to_port            = var.egress_to_port
  egress_protocol           = var.egress_protocol
  egress_cidr_blocks        = var.egress_cidr_blocks
}

module "role" {
  source                                = "../../modules/role"
  project                               = var.project
  environment                           = var.environment
  eks_cluster_policy_arns               = var.eks_cluster_policy_arns
  fargate_pod_execution_role_policy_arn = var.fargate_pod_execution_role_policy_arn
}

module "ecr" {
  source               = "../../modules/container/ecr"
  project              = var.project
  environment          = var.environment
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
}

module "eks-cluster" {
  source          = "../../modules/container/eks-cluster"
  cluster_name    = var.cluster_name
  eks_role_arn    = module.role.eks_cluster_role_arn
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnets
  eks_sg_id       = module.rds.eks_sg_id
  depends_on = [
    module.role
  ]
}

module "rds" {
  source            = "../../modules/rds"
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnets
  eks_cluster_sg_id = module.eks-cluster.cluster_security_group_id
  depends_on = [
    module.network,
    # module.eks-cluster
  ]
}

module "fargate_profile" {
  source                 = "../../modules/container/fargate-profile"
  project                = var.project
  environment            = var.environment
  cluster_name           = module.eks-cluster.cluster_name
  pod_execution_role_arn = module.role.fargate_pod_execution_role_arn
  subnet_ids             = module.network.private_subnets
  depends_on = [
    module.role,
    module.eks-cluster
  ]
}

module "eks-policy" {
  source = "../../modules/container/eks-policy"
  depends_on = [
    module.eks-cluster
  ]
}

module "lambda-recipe-generation" {
  source               = "../../modules/lambda/recipe-generation"
  lambda_key           = var.lambda_key
  lambda_bucket_name   = var.lambda_bucket_name
  lambda_role_name     = var.lambda_role_name
  lambda_function_name = var.lambda_function_name
  lambda_handler       = var.lambda_handler
  lambda_runtime       = var.lambda_runtime
  lambda_timeout       = var.lambda_timeout
  lambda_architectures = var.lambda_architectures
  openai_api_key       = var.openai_api_key
}

module "lambda-database-creation" {
  source       = "../../modules/lambda/database-creation"
  environment  = var.environment
  subnet_ids   = module.network.private_subnets
  lambda_sg_id = module.rds.lambda_sg_id
  depends_on = [
    module.rds
  ]
}

module "api_gateway" {
  source                 = "../../modules/api-gateway"
  environment            = var.environment
  api_name               = var.api_name
  protocol_type          = var.protocol_type
  cors_allow_origins     = var.cors_allow_origins
  cors_allow_methods     = var.cors_allow_methods
  cors_allow_headers     = var.cors_allow_headers
  cors_max_age           = var.cors_max_age
  integration_type       = var.integration_type
  integration_uri        = module.lambda-recipe-generation.lambda_invoke_arn
  payload_format_version = var.payload_format_version
  route_key              = var.route_key
  stage_name             = var.stage_name
  auto_deploy            = var.auto_deploy
  statement_id           = var.statement_id
  lambda_action          = var.lambda_action
  function_name          = module.lambda-recipe-generation.lambda_function_name
  principal              = var.principal
  ssm_parameter_name     = var.ssm_parameter_name
  ssm_parameter_type     = var.ssm_parameter_type
  depends_on = [
    module.lambda-recipe-generation
  ]
}
