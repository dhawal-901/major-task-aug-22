resource "aws_lb_listener" "redirect_to_https" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_lb_listener.forward_to_target_group]
}

resource "aws_lb_listener" "forward_to_target_group" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.Environment.my_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is Test Domain, You are not supposed to visit here.</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "jenkins-rule" {
  listener_arn = aws_lb_listener.forward_to_target_group.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_to_jenkins.arn
  }
  condition {
    host_header {
      values = [local.Environment.my_domains[0]]
    }
  }
  depends_on = [aws_lb_listener.forward_to_target_group, aws_lb_target_group.target_to_jenkins]
}

# resource "aws_lb_listener_rule" "app-rule" {
#   listener_arn = aws_lb_listener.forward_to_target_group.arn
#   priority     = 1
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_to_app.arn
#   }
#   condition {
#     host_header {
#       values = [local.Environment.my_domains[1]]
#     }
#   }
#   depends_on = [aws_lb_listener.forward_to_target_group, aws_lb_target_group.target_to_app]
# }


# resource "aws_lb_listener_rule" "app-rule" {
#   listener_arn = aws_lb_listener.forward_to_target_group.arn
#   priority     = 1
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_target_group_2.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/app*"]
#     }
#   }
# }
