output "cluster_endpoint" {
  value = var.create_eks_cluster ? aws_eks_cluster.cluster[0].endpoint : ""
}

output "cluster_security_group_id" {
  value = var.create_eks_cluster ? aws_security_group.eks_cluster_sg.id : ""
}

output "cluster_name" {
  value = var.create_eks_cluster ? aws_eks_cluster.cluster[0].name : ""
}

output "cluster_certificate_authority_data" {
  value = var.create_eks_cluster ? aws_eks_cluster.cluster[0].certificate_authority[0].data : ""
}

output "cluster_id" {
  value = var.create_eks_cluster ? aws_eks_cluster.cluster[0].id : ""
}
output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role[0].arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role[0].arn
}
