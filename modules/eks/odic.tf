//TLS certificates are used to secure communication between a client (such as a web browser) and a server, ensuring that data transmitted between them is encrypted and secure. 
data "tls_certificate" "eks" {
   
  url = var.oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.oidc_issuer_url
  
}