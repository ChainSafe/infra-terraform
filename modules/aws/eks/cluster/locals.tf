locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : var.default_variables.account_name

  # Networking
  cluster_security_group_additional_rules = {
    ingress_api_access = {
      description = "Allow private Kubernetes API ingress"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = tolist(var.api_access_cidrs)
    }

    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_health_check_from_lb_http = {
      description              = "Health Check nodes from LoadBalancers"
      protocol                 = "tcp"
      from_port                = 80
      to_port                  = 80
      type                     = "ingress"
      source_security_group_id = data.aws_security_group.web_access.id
    }

    ingress_health_check_from_lb_https = {
      description              = "Health Check nodes from LoadBalancers"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = data.aws_security_group.web_access.id
    }

    ingress_health_check_from_lb_ephemeral = {
      description              = "Health Check nodes from LoadBalancers"
      protocol                 = "tcp"
      from_port                = 1025
      to_port                  = 65535
      type                     = "ingress"
      source_security_group_id = data.aws_security_group.web_access.id
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}
