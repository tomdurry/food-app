variable "project" {
  type    = string
  default = "food-app"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use"
  type        = list(string)
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

variable "nat_gateway_count" {
  description = "The number of NAT Gateways to create for the VPC."
  type        = number
  default     = 1
}

variable "public_route_table_count" {
  description = "Number of public route tables"
  type        = number
  default     = 2
}

variable "private_route_table_count" {
  description = "Number of private route tables"
  type        = number
  default     = 2
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "internet_route_cidr" {
  description = "CIDR block for the internet route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "service_endpoints" {
  description = "List of service names for VPC endpoints"
  type        = map(string)
}

variable "http_port" {
  description = "Port for HTTP ingress"
  type        = number
  default     = 80
}

variable "ingress_protocol" {
  description = "Protocol for HTTP ingress"
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "From port for egress traffic"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "To port for egress traffic"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Protocol for egress traffic"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
