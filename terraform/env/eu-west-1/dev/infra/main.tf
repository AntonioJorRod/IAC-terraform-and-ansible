# --- Security Group principal ---
resource "aws_security_group" "main_west" {
  name        = "eu-west-1_main_sg"
  description = "SG general para ALB, EKS y Ansible Core en eu-west-1"
  vpc_id      = module.vpc_west.vpc_id

  ingress {
    description = "Permitir HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH solo desde tu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "eu-west-1_main_sg" })
}

# --- VPC con 2 públicas + 2 privadas + NATs + endpoints ---
module "vpc_west" {
  source          = "../../../../modules/aws/vpc"
  name_vpc        = "dev-vpc-west"
  cidr_block      = "10.20.0.0/16"
  public_subnets  = ["10.20.1.0/24","10.20.2.0/24"]
  private_subnets = ["10.20.101.0/24","10.20.102.0/24"]
  azs             = ["eu-west-1a","eu-west-1b"]
  tags            = var.tags
  region          = "eu-west-1"
}

# --- KMS para cifrado de secretos ---
module "kms_west" {
  source              = "../../../../modules/aws/kms"
  name                = "ansible-core-west"
  description         = "KMS para Ansible Core en eu-west-1"
  enable_key_rotation = true
  tags                = var.tags
}

# --- IAM para EKS ---
module "eks_iam_west" {
  source       = "../../../../modules/aws/iam/iam_eks"
  cluster_name = "eks-west"
}

# --- IAM para Ansible Core ---
module "iam_ansible_core_west" {
  source                = "../../../../modules/aws/iam/iam_ansible_core"
  role_name             = "ansible-core-role-west"
  instance_profile_name = "ansible-core-profile-west"
  kms_key_arn           = module.kms_west.kms_key_arn
}

# --- Secreto encriptado con KMS ---
resource "aws_kms_ciphertext" "ansible_secret_west" {
  key_id    = module.kms_west.kms_key_id
  plaintext = var.ansible_secret
}

# --- EKS (control plane gestionado, nodos en privadas) ---
module "eks_west" {
  source           = "../../../../modules/aws/eks"
  name             = "eks-west"
  cluster_role_arn = module.eks_iam_west.eks_cluster_role_arn
  node_role_arn    = module.eks_iam_west.eks_node_role_arn
  private_subnets  = module.vpc_west.private_subnet_ids
  instance_type    = var.eks_instance_type
  desired          = var.eks_desired
  min              = var.eks_min
  max              = var.eks_max
  tags_eks         = merge(var.tags, { Env = "dev-west" })
}

# --- EC2 Ansible Core en subnet privada ---
module "ec2_ansible_core_west" {
  source               = "../../../../modules/aws/ec2/ec2_ansible_core"
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  subnet_id            = module.vpc_west.private_subnet_ids[0]
  security_group_ids   = [aws_security_group.main_west.id]
  iam_instance_profile = module.iam_ansible_core_west.instance_profile_name
  key_name             = aws_key_pair.ansible_core.key_name
  tags_ansible_core    = var.tags_ansible_core
  region               = "eu-west-1"
  repo_url             = "https://github.com/AntonioJordan/IAC-terraform-and-ansible.git"
  inventory_rel_path   = "ansible/inventories/aws/dev/aws_ec2.yaml"
  ansible_secret_blob  = aws_kms_ciphertext.ansible_secret_west.ciphertext_blob
}

# --- ALB (en subnets públicas) ---
module "alb_west" {
  source            = "../../../../modules/aws/alb"
  name_alb          = "alb-west"
  vpc_id            = module.vpc_west.vpc_id
  public_subnets    = module.vpc_west.public_subnet_ids
  security_group_id = aws_security_group.main_west.id
}

# VPC Peering
module "vpc_peering_eu_us" {
  source = "../../../../modules/aws/vpc-peering"

  requester_vpc_id  = module.vpc_west.vpc_id
  accepter_vpc_id   = data.terraform_remote_state.us_infra.outputs.vpc_id
  requester_region  = "eu-west-1"
  accepter_region   = "us-east-1"
  tags              = merge(var.tags, { Env = "dev" })

  providers = {
    aws.requester = aws.eu
    aws.accepter  = aws.us
  }
}
