output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "waf_log_group_arn" {
  value = aws_cloudwatch_log_group.waf_logs.arn
}

output "waf_acl_arn" {
  value = aws_wafv2_web_acl.alb_waf[0].arn
}

