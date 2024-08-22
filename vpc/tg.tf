resource "aws_lb_target_group" "target_to_jenkins" {
  name     = local.Environment.target_group_1_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path                = "/login"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "target_to_jenkins_attachment" {
  for_each = {
    for k, v in aws_instance.my_private_instance :
    k => v
  }
  target_group_arn = aws_lb_target_group.target_to_jenkins.arn
  target_id        = each.value.id
  port             = 8080
}

# resource "aws_lb_target_group" "target_to_app" {
#   name     = local.Environment.target_group_2_name
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
#   health_check {
#     path                = "/"
#     port                = "80"
#     protocol            = "HTTP"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_target_group_attachment" "target_to_app_attachment" {
#   for_each = {
#     for k, v in aws_instance.my_private_instance :
#     k => v
#   }
#   target_group_arn = aws_lb_target_group.target_to_app.arn
#   target_id        = each.value.id
#   port             = 80
# }
