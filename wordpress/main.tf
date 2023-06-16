resource "aws_instance" "wordpress" {
  for_each = { for idx, subnet_id in var.public_subnet_id : idx => subnet_id if idx < 2 }
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.default.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  associate_public_ip_address = true
  source_dest_check           = false
  root_block_device {
    delete_on_termination = false
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp2"
  }
  tags = module.label.tags
}


resource "aws_security_group" "default" {
  name   = module.label.id
  vpc_id = var.vpc_id
  tags   = module.label.tags

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
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = toset(var.ids_sg)

  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = each.value
  security_group_id        = aws_security_group.default.id
}

resource "aws_security_group_rule" "ingresss2" {
  for_each                 = toset(var.ids_sg)
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = each.value
  security_group_id        = aws_security_group.default.id
}


resource "aws_security_group_rule" "ingress_ips" {
  for_each = toset(var.white_list_ips)

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.default.id
}



output "fqdn" {
  value = aws_route53_record.default.fqdn
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
    value       = values(aws_instance.wordpress)[*].private_ip

}

output "security_group_id" {
  value = aws_security_group.default.id
}
