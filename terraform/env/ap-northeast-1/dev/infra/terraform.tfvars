# --- VPC ---
name_vpc        = "dev-vpc-west"
cidr_block      = "10.20.0.0/16"
region          = "ap-northeast-1"
azs             = ["ap-northeast-1a", "ap-northeast-1b"]
public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnets = ["10.20.101.0/24", "10.20.102.0/24"]

tags = {
  Env     = "dev-west"
  Project = "eks-cluster"
}

# --- EKS ---
eks_name          = "dev-eks-west"
eks_instance_type = "t4g.micro"
eks_desired       = 3
eks_min           = 2
eks_max           = 5

# --- EC2 Ansible Core ---
instance_type = "t4g.micro"
key_name      = "mi-keypair-west"

tags_ansible_core = {
  Name    = "ansible-core-west"
  Env     = "dev-west"
  Project = "eks-cluster"
}

# --- IAM para Ansible Core ---
iam_control_role_name             = "ansible-core-role-west"
iam_control_instance_profile_name = "ansible-core-profile-west"

# --- KMS ---
ansible_secret = "clave-super-secreta"

# --- ALB ---
name_alb = "dev-alb-west"

# --- Seguridad ---
my_ip = "80.24.35.17/32"

# --- Route53 ---
domain_name = "idontgonnapayadomain.com"
