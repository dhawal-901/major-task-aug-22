resource "aws_security_group" "my_alb_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = local.Environment.alb_sg_name
  description = "Allow 80, 443 only"
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.Environment.alb_sg_name
  }
}

resource "aws_security_group" "my_public_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = local.Environment.public_sg_name
  description = "Allow 22 only"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.Environment.public_sg_name
  }
}
resource "aws_security_group" "my_private_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = local.Environment.private_sg_name
  description = "Allow 8080 from alb security group"
  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.my_alb_sg.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.my_alb_sg.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.Environment.private_sg_name
  }
}