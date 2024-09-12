data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs-task-execution-role" {
    version = "2012-10-17"
    statement {
      sid = ""
      effect = "Allow"
      actions = ["sts:AssumeRole"]
      principals {
          type = "Service"
          identifiers = ["ecs-tasks.amazonaws.com"]
      }
    }

}

resource "aws_iam_role" "ecs-task-execution-role" {
    name = "ecs-task-execution-role"
    assume_role_policy = data.aws_iam_policy_document.ecs-task-execution-role.json
}


resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
    role = aws_iam_role.ecs-task-execution-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_secrets_access_policy" {
    name   = "ecs-task-secrets-access-policy"
    role   = aws_iam_role.ecs-task-execution-role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gitlab-access*"
        }
    ]
}
EOF
}