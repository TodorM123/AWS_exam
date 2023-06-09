resource "aws_iam_role" "ssm_mgmt" {
  name = "ssm-mgmt"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ssm_mgmt_attachment" {
  role       = aws_iam_role.ssm_mgmt.id
  policy_arn = var.policy_arn
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.ssm_mgmt.name
}

resource "aws_iam_role_policy_attachment" "Cloud_watch_attachment" {
  role       = aws_iam_role.ssm_mgmt.id
  policy_arn = var.policy_arn_Cloud_Watch
}

