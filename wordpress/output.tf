output "aws_alb_arn" {
  value = aws_lb.wordpress.arn
}

output "alb_url" {
  value = "http://${aws_lb.wordpress.dns_name}"
}

output "target_group_arn" {
  value = aws_lb_target_group.wordp-tg.arn
}
