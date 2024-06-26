# Creating IAM Role for EKS Cluster (control-plane).
resource "aws_iam_role" "eks_cluster_role" {
  name = var.cluster_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    env = var.env_name
  }
}

# Attaching the policy "AmazonEKSVPCResourceController" to Cluster (control-plane).
resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" ## aws_iam_policy.policy.arn
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html

# Attaching policy AmazonEKSVPCResourceController to cluster role  
resource "aws_iam_role_policy_attachment" "policy_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Creating Worker Node-Group Role
resource "aws_iam_role" "eks_node_group_role" {
  name = var.eks_node_group_role_name

  assume_role_policy = jsonencode({ ## aws_iam_policy.policy.arn
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    env = var.env_name
  }
}

# Attaching policy AmazonEKSWorkerNodePolicy to node-group role.
resource "aws_iam_role_policy_attachment" "policy_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

# Attaching policy AmazonEKS_CNI_Policy to node-group role  
resource "aws_iam_role_policy_attachment" "policy_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

# Attaching policy AmazonEC2ContainerRegistryReadOnly to node-group role  
resource "aws_iam_role_policy_attachment" "policy_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}
