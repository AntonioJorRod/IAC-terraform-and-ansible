# =================================================================
# EJEMPLOS DE IMPLEMENTACIÓN AVANZADA PARA AWS TRANSFER FAMILY
# =================================================================
# Los siguientes ejemplos muestran diferentes configuraciones
# comunes para el módulo Transfer Family. Estos son solo ejemplos
# y deben ser adaptados según tus necesidades específicas.

# -----------------------------------------------------------------
# EJEMPLO 1: Servidor SFTP público con múltiples usuarios y acceso S3
# -----------------------------------------------------------------
/*
module "transfer_family_public" {
  source = "../"

  name                       = "public-sftp-server"
  protocols                  = ["SFTP"]
  identity_provider_type     = "SERVICE_MANAGED"
  endpoint_type              = "PUBLIC"
  security_policy_name       = "TransferSecurityPolicy-2020-06"
  create_log_group           = true
  log_retention_days         = 90

  users = {
    "operations" = {
      role_arn       = ""
      home_directory = "/operations-bucket/operations"
      policy         = ""
      ssh_keys = {
        "ops-key-1" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
        "ops-key-2" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ..."
      }
    }
    "finance" = {
      role_arn       = ""
      home_directory = "/finance-bucket/finance"
      policy         = ""
      ssh_keys = {
        "finance-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
      }
    }
    "hr" = {
      role_arn       = ""
      home_directory = "/hr-bucket/hr"
      policy         = ""
      ssh_keys = {
        "hr-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
      }
    }
  }

  tags = {
    Environment = "production"
    Purpose     = "file-transfer"
    Team        = "platform"
  }
}
*/

# -----------------------------------------------------------------
# EJEMPLO 2: Servidor SFTP en VPC con integración EFS
# -----------------------------------------------------------------
/*
module "transfer_family_vpc_efs" {
  source = "../"

  name                       = "internal-sftp-efs"
  protocols                  = ["SFTP"]
  identity_provider_type     = "SERVICE_MANAGED"
  endpoint_type              = "VPC"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnet_ids
  security_group_ids         = [aws_security_group.sftp_internal.id]
  create_security_group      = false
  allowed_cidr_blocks        = ["10.0.0.0/8"]
  create_log_group           = true
  log_retention_days         = 30

  users = {
    "developer1" = {
      role_arn       = ""
      home_directory = "/fs-12345678/shared/dev1"
      policy         = ""
      ssh_keys = {
        "dev-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
      }
    }
    "developer2" = {
      role_arn       = ""
      home_directory = "/fs-12345678/shared/dev2"
      policy         = ""
      ssh_keys = {
        "dev-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ..."
      }
    }
  }

  tags = {
    Environment = "development"
    Purpose     = "internal-file-share"
  }
}
*/

# -----------------------------------------------------------------
# EJEMPLO 3: Servidor multi-protocolo (SFTP + FTP + FTPS)
# -----------------------------------------------------------------
/*
module "transfer_family_multiprotocol" {
  source = "../"

  name                       = "enterprise-file-server"
  protocols                  = ["SFTP", "FTP", "FTPS"]
  identity_provider_type     = "SERVICE_MANAGED"
  endpoint_type              = "VPC"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnet_ids
  address_allocation_ids     = var.eip_allocation_ids
  security_group_ids         = [aws_security_group.enterprise_sftp.id]
  create_security_group      = false
  security_policy_name       = "TransferSecurityPolicy-2020-06"
  create_log_group           = true
  log_retention_days         = 60

  users = {
    "enterprise_user" = {
      role_arn       = ""
      home_directory = "/enterprise-bucket/files"
      policy         = ""
      ssh_keys = {
        "enterprise-key" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
      }
    }
  }

  tags = {
    Environment = "production"
    Purpose     = "enterprise-file-transfer"
    Compliance  = "required"
  }
}
*/

# Para más ejemplos, consulta el archivo README.md
