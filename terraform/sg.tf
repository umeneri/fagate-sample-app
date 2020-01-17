resource "aws_security_group" "app_sg" {
  name = "${var.env}-${var.task_name}-sg"
  vpc_id = "${aws_vpc.app_vpc.id}"

  tags = {
    Name = "${var.env}-${var.task_name}-sg"
  }
}

// 外部からのアクセスは80番ポートを許可する
resource "aws_security_group_rule" "ingress" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"]

  security_group_id = "${aws_security_group.app_sg.id}"
}

// 内部からのアクセスはすべてを許可する
resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"]

  security_group_id = "${aws_security_group.app_sg.id}"
}
