resource "aws_iam_role" "app_ecs_task_execution_role" {
  name = "ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.app_task_role_assume_role_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "app_ecs_task_execution_role_policy_attachment" {
  role = "${aws_iam_role.app_ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "app_task_role_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

