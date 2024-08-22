module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.Environment.vpc_name
  cidr = local.Environment.vpc_cidr

  azs             = local.Environment.azs
  private_subnets = local.Environment.private_subnets
  public_subnets  = local.Environment.public_subnets

  enable_nat_gateway     = true
  enable_vpn_gateway     = false
  one_nat_gateway_per_az = false
  single_nat_gateway     = true

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}