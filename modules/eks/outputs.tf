output "cluster_endpoint" {
  description = "The cluster endpoint to communicate with the cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "base64 encoded EKS Certificate Authority Data"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The EKS cluster ID."
  value       = module.eks.cluster_name
}

output "oidc_provider_arn" {
  description = "The OIDC provider ARN."
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL."
  value       = module.eks.cluster_oidc_issuer_url
}

output "node_security_group_id" {
  description = "ID of the node shared security group."
  value       = module.eks.node_security_group_id
}
