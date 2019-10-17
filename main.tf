resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "RDS security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks
  }

  tags = var.tags
}

module "rds" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds?ref=v2.5.0"

  name                 = var.name
  identifier           = var.identifier
  instance_class       = var.instance_class
  engine               = var.engine
  family               = var.family
  major_engine_version = var.major_engine_version
  engine_version       = var.engine_version
  
  allocated_storage    = var.allocated_storage
  storage_encrypted    = var.storage_encrypted

  username             = data.vault_generic_secret.rds_credentials.data["username"]
  password             = data.vault_generic_secret.rds_credentials.data["password"]

  port                 = var.port
  
  backup_window        = var.backup_window
  maintenance_window   = var.maintenance_window
  
  subnet_ids             = data.terraform_remote_state.vpc.outputs.private_subnets
  multi_az               = var.multi_az
  vpc_security_group_ids = list(aws_security_group.rds_sg.id)

  tags = var.tags
}
