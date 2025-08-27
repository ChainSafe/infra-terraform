resource "aws_security_group" "web" {
  name = "${local.vpc_name}-web"

  description = "Web Access SG"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${local.vpc_name}-web"
      type = "web-access"
    }
  )
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_security_group" "web_public" {
  name = "${local.vpc_name}-public-web"

  description = "Web Access from everywhere SG"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${local.vpc_name}-public-web"
      type = "public-web-access"
    }
  )

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "aws_security_group_rule" "web_http_ingress" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  description = "User connections to HTTP"
  cidr_blocks = local.company_networks
}

resource "aws_security_group_rule" "web_https_ingress" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "User connections to HTTPS"
  cidr_blocks = local.company_networks
}

resource "aws_security_group_rule" "web_egress" {
  security_group_id = aws_security_group.web.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Web egress traffic"
  #trivy:ignore:AVD-AWS-0104
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_public_http_ingress" {
  security_group_id = aws_security_group.web_public.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  description = "User connections to HTTP"
  #trivy:ignore:AVD-AWS-0107
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_public_https_ingress" {
  security_group_id = aws_security_group.web_public.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "User connections to HTTPS"
  #trivy:ignore:AVD-AWS-0107
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_public_egress" {
  security_group_id = aws_security_group.web_public.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Web egress traffic"
  #trivy:ignore:AVD-AWS-0104
  cidr_blocks = ["0.0.0.0/0"]
}
