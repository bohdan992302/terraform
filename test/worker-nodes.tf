resource "aws_iam_role" "worker-node" {
  name = "terraform-eks-worker-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-node.name
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-node.name
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-node.name
}

resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.kubernetes-new.name
  node_group_name = "worker-nodes"
  node_role_arn   = aws_iam_role.worker-node.arn
  subnet_ids      = aws_subnet.test[*].id
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}