# Terraform AWS RDS

Terraform module which creates an RDS associated to a security group in an existing VPC.

Master username and password are retrieved from Hashicorp Vault.

## Public access

If the variable `allowed_public_ips` is defined, RDS will be made publicly accessible with whitelisting to the provided IPs/CIDR blocks. Otherwise RDS access will be private to its VPC.