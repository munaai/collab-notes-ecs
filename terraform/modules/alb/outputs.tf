output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "waf_acl_arn" {
  value = try(aws_wafv2_web_acl.alb_waf[0].arn, null)
}

