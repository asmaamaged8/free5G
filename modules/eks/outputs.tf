output "tls_certificate_arn" {
  description = "The ARN of the TLS certificate."
  value       = data.tls_certificate.eks.certificates[0].arn
}



output "eks_id" {
  value = aws_iam_role.asmaa_eks_cluster.id
}



// to stablish trust between iam and kubernetes service account 
//output "openid_provider_arn" {
 // value = aws_iam_openid_connect_provider.eks[0].arn}
