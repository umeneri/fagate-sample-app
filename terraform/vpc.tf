resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags =  {
    Name = "${var.category}-vpc"
  }
}

resource "aws_subnet" "app_public_subnet_a" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags =  {
    Name = "${var.task_name}-public-subnet-a"
  }
}

resource "aws_subnet" "app_public_subnet_c" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}c"

  tags =  {
    Name = "${var.task_name}-public-subnet-c"
  }
}

resource "aws_subnet" "app_private_subnet_a" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}a"

  tags =  {
    Name = "${var.task_name}-private-subnet-a"
  }
}

resource "aws_subnet" "app_private_subnet_c" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}c"

  tags =  {
    Name = "${var.task_name}-private-subnet-c"
  }
}

resource "aws_route_table" "app_public_route_table" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_internet_gateway.id}"
  }

  tags =  {
    Name = "${var.category}-public-rt"
  }
}

resource "aws_route_table" "app_private_route_table" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.app_nat_gateway.id}"
  }

  tags =  {
    Name = "${var.category}-private-rt"
  }
}

resource "aws_route_table_association" "app_public_table_association_a" {
  subnet_id = "${aws_subnet.app_public_subnet_a.id}"
  route_table_id = "${aws_route_table.app_public_route_table.id}"
}

resource "aws_route_table_association" "app_public_table_association_c" {
  subnet_id = "${aws_subnet.app_public_subnet_c.id}"
  route_table_id = "${aws_route_table.app_public_route_table.id}"
}

resource "aws_route_table_association" "app_table_association_a" {
  subnet_id = "${aws_subnet.app_private_subnet_a.id}"
  route_table_id = "${aws_route_table.app_private_route_table.id}"
}

resource "aws_route_table_association" "app_table_association_c" {
  subnet_id = "${aws_subnet.app_private_subnet_c.id}"
  route_table_id = "${aws_route_table.app_private_route_table.id}"
}

// 外部からECSへアクセスするために必要
resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  tags =  {
    Name = "${var.category}-igw"
  }
}

// 内部からECRへアクセスするために必要
resource "aws_nat_gateway" "app_nat_gateway" {
  allocation_id = "${aws_eip.app_nat_gateway_eip.id}"
  subnet_id     = "${aws_subnet.app_public_subnet_a.id}"

  tags = {
    Name = "${var.category}-ngw"
  }
}

// ナットゲートウェイ用のEIP
resource "aws_eip" "app_nat_gateway_eip" {
  vpc = true

  tags = {
    Name = "${var.category}-ip"
  }
}
