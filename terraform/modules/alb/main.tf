terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Get current AWS account details
data "aws_caller_identity" "current" {}

resource "aws_lb" "this" {
  name                       = var.alb_name
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids
  security_groups            = var.alb_security_group_ids
  internal                   = var.alb_internal
  enable_deletion_protection = true
  drop_invalid_header_fields = true

  access_logs {
    bucket  = "my-alb-logs-muna"
    enabled = true
  }
}

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.https_listener_port
  protocol          = var.https_listener_protocol

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_listener_port
      protocol    = "HTTPS"
      status_code = var.http_redirect_status_code
    }
  }
}

resource "aws_wafv2_web_acl" "alb_waf" {
  count       = var.enable_waf ? 1 : 0
  name        = var.waf_name
  scope       = var.waf_scope
  description = "WAF for ALB"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf_metric_name
    sampled_requests_enabled   = true
  }

  rule {
    name     = var.waf_rule_name
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRules"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = aws_lb.this.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf[0].arn
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = "my-alb-logs-muna"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowALBLogs",
        Effect = "Allow",
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::my-alb-logs-muna/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      }
    ]
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "alb_waf_logging" {
  count                   = var.enable_waf ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.alb_waf[0].arn
}

resource "aws_kms_key" "cloudwatch_logs" {
  description             = "KMS key for encrypting CloudWatch logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-policy"
    Statement = [
      {
        Sid    = "Allow account root full access"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/alb"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn
}
