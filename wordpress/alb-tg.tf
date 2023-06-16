  resource "aws_lb_target_group" "wordp-tg" {
    name        = var.name
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id

    health_check {
      enabled             = true
      path                = "/health"
      protocol            = "HTTP"
      port                = "traffic-port"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
      interval            = 30
      matcher             = "200-399"
    }
  }



  resource "aws_lb" "wordpress" {
    name               = "wordpress-alb"
    load_balancer_type = "application"
    subnets            = var.public_subnet_id
    /* security_groups    = [aws_security_group.alb-sg.id] */

    tags = module.label.tags
  }

  resource "aws_lb_target_group_attachment" "example" {
    for_each         = aws_instance.wordpress
    target_group_arn = aws_lb_target_group.wordp-tg.arn
    target_id        = each.value.private_ip
    port             = 80
  }

 resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wordp-tg.arn
  }
}

  
resource "aws_route53_record" "default" {
  zone_id = var.parent_zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = aws_lb.wordpress.dns_name
    zone_id                = aws_lb.wordpress.zone_id
    evaluate_target_health = true
  }
}
