resource "aws_iam_role" "kubernetes-new" {
  name = "terraform-eks-kubernetes-new"

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
}

resource "aws_iam_role_policy_attachment" "kubernetes-new-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.kubernetes-new.name
}

resource "aws_iam_role_policy_attachment" "kubernetes-new-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.kubernetes-new.name
}

resource "aws_security_group" "kubernetes-new" {
  name        = "terraform-eks-kubernetes-new"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-kubernetes-new"
  }
}

resource "aws_security_group_rule" "kubernetes-new-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes-new.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "kubernetes-new" {
  name     = var.cluster-name
  role_arn = aws_iam_role.kubernetes-new.arn

  vpc_config {
    security_group_ids = [aws_security_group.kubernetes-new.id]
    subnet_ids         = aws_subnet.test[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubernetes-new-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubernetes-new-AmazonEKSServicePolicy,
  ]
}