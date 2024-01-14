# Create a VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_eks_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "my_eks_igw"
  }
}

# Create Subnets
resource "aws_subnet" "subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "my_eks_subnet_${count.index}"
  }
}

# Create Route Table
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "my_eks_routetable"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "rta" {
  count          = length(aws_subnet.subnet)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.routetable.id
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  count = var.create_eks_cluster ? 1 : 0
  name  = "my_eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attaching the necessary policies to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = var.create_eks_cluster ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  count      = var.create_eks_cluster ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role[0].name
}

# Security group for the EKS cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "my_eks_cluster_sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.eks_vpc.id
}

# EKS Cluster
resource "aws_eks_cluster" "cluster" {
  count    = var.create_eks_cluster ? 1 : 0
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role[0].arn
  vpc_config {
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    subnet_ids         = aws_subnet.subnet[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
    aws_route_table_association.rta
  ]
}

# ConfigMap aws-auth for EKS
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role.eks_node_role
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([{
      rolearn  = aws_iam_role.eks_cluster_role[0].arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
      }, {
      rolearn  = aws_iam_role.eks_node_role[0].arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
      }, {
      rolearn  = aws_iam_role.eks_cluster_role[0].arn
      username = "my_eks_cluster_role"
      groups   = ["system:masters"]
    }])
  }
}

# EKS Node Group
resource "aws_eks_node_group" "node_group" {
  count           = var.create_eks_cluster ? 1 : 0
  cluster_name    = aws_eks_cluster.cluster[0].name
  node_group_name = "my_eks_node_group"
  node_role_arn   = aws_iam_role.eks_node_role[0].arn
  subnet_ids      = aws_subnet.subnet[*].id

  scaling_config {
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_eks_cluster.cluster
  ]
}
# IAM role for EKS node group
resource "aws_iam_role" "eks_node_role" {
  count = var.create_eks_cluster ? 1 : 0
  name  = "my_eks_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attaching necessary policies to the EKS node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  count      = var.create_eks_cluster ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  count      = var.create_eks_cluster ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role[0].name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read" {
  count      = var.create_eks_cluster ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role[0].name
}
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster[0].name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster[0].name
}