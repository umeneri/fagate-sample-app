//resource "aws_instance" "bastion" {
//  ami           = "ami-0f9af249e7fa6f61b"
//  instance_type = "t2.nano"
//  security_groups = ["${aws_security_group.bastion_sg.id}"]
//  key_name = "terraform"
//  subnet_id = "${aws_subnet.app_public_subnet_a.id}"
//  associate_public_ip_address = true
//
//  tags = {
//    Name = "bastion"
//  }
//}
//
//resource "aws_security_group" "bastion_sg" {
//    name = "${var.env}-bastion-sg"
//    vpc_id = "${aws_vpc.app_vpc.id}"
//
//    tags = {
//      Name = "${var.env}-bastion-sg"
//    }
//}
//
//
//resource "aws_security_group_rule" "bastion_ingress" {
//  type = "ingress"
//  from_port = 22
//  to_port = 22
//  protocol = "tcp"
//  cidr_blocks = [
//    "0.0.0.0/0"]
//
//  security_group_id = "${aws_security_group.bastion_sg.id}"
//}
//
//resource "aws_security_group_rule" "bastion_egress" {
//  type = "egress"
//  from_port = 0
//  to_port = 0
//  protocol = "-1"
//  cidr_blocks = [
//    "0.0.0.0/0"]
//
//  security_group_id = "${aws_security_group.bastion_sg.id}"
//}
//
