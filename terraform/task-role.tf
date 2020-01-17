resource "aws_iam_role" "app_task_role" {
  name               = "${var.env}-${var.task_name}"
  assume_role_policy = "${data.aws_iam_policy_document.app_task_role_assume_role_policy_document.json}"
}

resource "aws_iam_role_policy" "app_task_policy" {
  name   = "${var.env}-${var.task_name}"
  role   = "${aws_iam_role.app_task_role.id}"
  policy = "${data.aws_iam_policy_document.app_task_policy_document.json}"
}

data "aws_iam_policy_document" "app_task_policy_document" {
  statement {
    actions = [
      "ecs:DescribeClusters",
    ]

    resources = [
      "${aws_ecs_cluster.app_ecs_cluster.arn}",
    ]
  }
}

