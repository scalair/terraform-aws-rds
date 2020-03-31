resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "RDS security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "private_ingress" {
  security_group_id = aws_security_group.rds_sg.id

  type        = "ingress"
  from_port   = var.port
  to_port     = var.port
  protocol    = "tcp"
  cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks
}

resource "aws_security_group_rule" "public_ingress" {
  security_group_id = aws_security_group.rds_sg.id

  count = length(var.allowed_public_ips) > 0 ? 1 : 0

  type        = "ingress"
  from_port   = var.port
  to_port     = var.port
  protocol    = "tcp"
  cidr_blocks = var.allowed_public_ips
}

module "rds" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds?ref=v2.13.0"

  name                 = var.name
  identifier           = var.identifier
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  major_engine_version = var.major_engine_version
  family               = var.family

  publicly_accessible  = length(var.allowed_public_ips) > 0

  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  allocated_storage = var.allocated_storage
  storage_encrypted = var.storage_encrypted

  username = data.vault_generic_secret.rds_credentials.data["username"]
  password = data.vault_generic_secret.rds_credentials.data["password"]

  port = var.port

  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  backup_retention_period = var.backup_retention_period

  subnet_ids             = data.terraform_remote_state.vpc.outputs.public_subnets
  multi_az               = var.multi_az
  vpc_security_group_ids = list(aws_security_group.rds_sg.id)

  tags = var.tags
}

resource "aws_route53_record" "rds_record" {
  count = var.dns_alias == "" ? 0 : 1

  name    = var.dns_alias
  ttl     = var.dns_ttl
  zone_id = var.route_53_zone_id
  type    = "CNAME"
  records = [module.rds.this_db_instance_address]
}