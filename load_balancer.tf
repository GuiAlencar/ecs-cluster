resource "aws_security_group" "lb" {
  name = format("%s-load-balancer", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group_rule" "ingress_80" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks = ["0.0.0.0/0"]
  description = "Liberando trafego na porta 80"
}

resource "aws_security_group_rule" "ingress_443" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks = ["0.0.0.0/0"]
  description = "Liberando trafego na porta 443"
}

resource "aws_lb" "main" {
  name               = format("%s-ingress", var.project_name)
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.lb.id]

  subnets            = [
    data.aws_ssm_parameter.public_subnet_1a.value,
    data.aws_ssm_parameter.public_subnet_1b.value,
    data.aws_ssm_parameter.public_subnet_1c.value
  ]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection = false
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
        content_type = "text/plain"
        message_body = "LinuxTips"
        status_code  = "200"
    }
  }
}