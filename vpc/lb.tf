resource "aws_lb" "my_alb" {
  name               = local.Environment.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = true

  tags = {
    Environment = terraform.workspace
  }
}