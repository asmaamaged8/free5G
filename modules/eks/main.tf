# create an eks cluster

resource "aws_iam_role" "asmaa_eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
//AmazonEKSClusterPolicy allows eks to create ec2 instances and load balancers,This policy provides permissions for managing Amazon EKS clusters. It allows actions such as creating, deleting, updating, and listing EKS clusters, as well as attaching and detaching IAM policies to worker node IAM roles associated with the cluster. 
resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" 
  role       = aws_iam_role.asmaa_eks_cluster.name
}

# Additional policies can be attached as needed
# resource "aws_iam_role_policy_attachment" "additional_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/YourAdditionalPolicy"
#   role       = aws_iam_role.eks_cluster.name
# }





resource "aws_eks_cluster" "asmaa_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.asmaa_eks_cluster.arn

  vpc_config {
    #subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]
    security_group_ids = [var.eks_security_group_id]
    subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id, var.private_subnet_3_id]
    #endpoint_private_access = false 
    #endpoint_public_access = false 
  }
  

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
     aws_iam_role_policy_attachment.eks_cluster_policies,
   
  ]
  
 
}



# create nodes
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" # Example policy, adjust as needed
  role       = aws_iam_role.eks_node_group_role.name
  
}

resource "aws_iam_role_policy_attachment" "eks_cni_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Example policy, adjust as needed
  role       = aws_iam_role.eks_node_group_role.name
}
# CNI plugins enable pods within a Kubernetes cluster to communicate with each other, as well as with external resources, by managing networking configurations

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Adding AmazonEC2ContainerRegistryReadOnly policy
  role       = aws_iam_role.eks_node_group_role.name
}
#This policy grants read-only access to Amazon ECR repositories, allowing the associated IAM role to pull container images 



#create nodes
resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.asmaa_eks_cluster.name    
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id, var.private_subnet_3_id]
  capacity_type = var.capacity_type

  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size

    # desired_size = each.value.scaling_config.desired_size
    # max_size     = each.value.scaling_config.max_size
    # min_size     = each.value.scaling_config.min_size

  }

  update_config {
    max_unavailable = 1
  }
// helpful for using nodeselector or affinity to bind pods with nodes
  #labels ={
    #role = each.key}

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_policies,
    aws_iam_role_policy_attachment.eks_cni_policies,
    aws_iam_role_policy_attachment.ecr_read_only_policy,
    
  
  ]
} 



