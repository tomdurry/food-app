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
  eks_cluster_node_policy_arns          = var.eks_cluster_node_policy_arns
  fargate_pod_execution_role_policy_arn = var.fargate_pod_execution_role_policy_arn
}

module "ecr" {
  source               = "../../modules/container/ecr"
  project              = var.project
  environment          = var.environment
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
  scan_on_push         = var.scan_on_push
}

module "eks-cluster" {
  source                                      = "../../modules/container/eks-cluster"
  project                                     = var.project
  environment                                 = var.environment
  addon_name                                  = var.addon_name
  cluster_name                                = var.cluster_name
  eks_role_arn                                = module.role.eks_cluster_role_arn
  node_group_role_arn                         = module.role.node_group_role_arn
  cluster_version                             = var.cluster_version
  authentication_mode                         = var.authentication_mode
  bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  vpc_id                                      = module.network.vpc_id
  subnet_ids                                  = module.network.private_subnets
  desired_size                                = var.desired_size
  max_size                                    = var.max_size
  min_size                                    = var.min_size
  instance_types                              = var.instance_types
  ami_type                                    = var.ami_type
  depends_on = [
    module.role
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
  source      = "../../modules/container/eks-policy"
  project     = var.project
  environment = var.environment
  depends_on = [
    module.eks-cluster
  ]
}

module "lambda-recipe-generation" {
  source               = "../../modules/lambda/recipe-generation"
  project              = var.project
  environment          = var.environment
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

module "rds" {
  source                  = "../../modules/rds"
  project                 = var.project
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  subnet_ids              = module.network.private_subnets
  eks_cluster_sg_id       = module.eks-cluster.cluster_security_group_id
  lambda_sg_from_port     = var.lambda_sg_from_port
  lambda_sg_to_port       = var.lambda_sg_to_port
  lambda_sg_protocol      = var.lambda_sg_protocol
  lambda_sg_cidr_blocks   = var.lambda_sg_cidr_blocks
  rds_sg_from_port        = var.rds_sg_from_port
  rds_sg_to_port          = var.rds_sg_to_port
  rds_sg_protocol         = var.rds_sg_protocol
  rds_sg_cidr_blocks      = var.rds_sg_cidr_blocks
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  publicly_accessible     = var.publicly_accessible
  lambda_to_rds_type      = var.lambda_to_rds_type
  lambda_to_rds_from_port = var.lambda_to_rds_from_port
  lambda_to_rds_to_port   = var.lambda_to_rds_to_port
  lambda_to_rds_protocol  = var.lambda_to_rds_protocol
  eks_to_rds_rds_type     = var.eks_to_rds_rds_type
  eks_to_rds_from_port    = var.eks_to_rds_from_port
  eks_to_rds_to_port      = var.eks_to_rds_to_port
  eks_to_rds_protocol     = var.eks_to_rds_protocol
  depends_on = [
    module.network,
    module.eks-cluster
  ]
}

module "lambda-database-creation" {
  source       = "../../modules/lambda/database-creation"
  project      = var.project
  environment  = var.environment
  region       = var.region
  subnet_ids   = module.network.private_subnets
  lambda_sg_id = module.rds.lambda_sg_id
  depends_on = [
    module.rds
  ]
}

module "api_gateway" {
  source                 = "../../modules/api-gateway"
  project                = var.project
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

module "oai" {
  source = "../../modules/oai"
}

module "acm" {
  source      = "../../modules/acm"
  project     = var.project
  environment = var.environment
}

module "s3" {
  source                  = "../../modules/s3"
  project                 = var.project
  environment             = var.environment
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  oai_iam_arn             = module.oai.oai_iam_arn
  depends_on = [
    module.oai
  ]
}

module "route53_us_east_1" {
  source = "../../modules/route53/us_east_1"
  providers = {
    aws = aws.us_east_1
  }
  cloudfront_certificate_arn = module.acm.cloudfront_certificate_arn
  domain_validation_options  = module.acm.cloudfront_domain_validation_options
  ttl                        = var.ttl
  depends_on = [
    module.acm
  ]
}

module "route53_ap-northeast-1" {
  source                     = "../../modules/route53/ap-northeast-1"
  cloudfront_certificate_arn = module.acm.lb_certificate_arn
  domain_validation_options  = module.acm.lb_domain_validation_options
  ttl                        = var.ttl
  depends_on = [
    module.acm
  ]
}


module "cloudfront" {
  source                              = "../../modules/cloudfront"
  project                             = var.project
  environment                         = var.environment
  origin_id                           = var.origin_id
  enabled                             = var.enabled
  default_root_object                 = var.default_root_object
  domain_name                         = var.domain_name
  allowed_methods                     = var.allowed_methods
  cached_methods                      = var.cached_methods
  target_origin_id                    = var.target_origin_id
  query_string                        = var.query_string
  forward                             = var.forward
  viewer_protocol_policy              = var.viewer_protocol_policy
  error_code                          = var.error_code
  response_code                       = var.response_code
  response_page_path                  = var.response_page_path
  ssl_support_method                  = var.ssl_support_method
  minimum_protocol_version            = var.minimum_protocol_version
  restriction_type                    = var.restriction_type
  type                                = var.type
  evaluate_target_health              = var.evaluate_target_health
  oai_cloudfront_access_identity_path = module.oai.oai_cloudfront_access_identity_path
  oai_iam_arn                         = module.oai.oai_iam_arn
  frontend_bucket_arn                 = module.s3.frontend_bucket_arn
  bucket_domain_name                  = module.s3.bucket_domain_name
  cloudfront_certificate_arn          = module.acm.cloudfront_certificate_arn
  route53_zone_id                     = module.route53_us_east_1.route53_zone_id

  depends_on = [
    module.oai,
    module.acm,
    module.s3,
    module.route53_us_east_1
  ]
}
