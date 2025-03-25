resource "aws_iam_user" "tracking_user" {
  name = "tracking-app-user"
}

resource "aws_iam_access_key" "tracking_user_key" {
  user = aws_iam_user.tracking_user.name
}

resource "aws_iam_policy" "sqs_full_access" {
  name        = "tracking-app-sqs-policy"
  description = "Allow full SQS access to the tracking app"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sqs:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "tracking_user_attach" {
  user       = aws_iam_user.tracking_user.name
  policy_arn = aws_iam_policy.sqs_full_access.arn
}
