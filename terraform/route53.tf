resource "aws_route53_zone" "main" {
  name = "employee-mgmt-demo.com"

  tags = {
    Name = "employee-mgmt-hosted-zone"
  }
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.employee-mgmt-demo.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

/*
resource "aws_acm_certificate" "app" {
  domain_name       = "api.employee-mgmt-demo.com"
  validation_method = "DNS"
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.app.arn
  # ... target group forward
}
*/