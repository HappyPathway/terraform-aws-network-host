provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ssh" {
  name        = "${lookup(var.resource_tags, "Owner")}-${lookup(var.resource_tags, "env")}-${var.vpc_id}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "service" {
  count       = "${var.public_service_port != "" ? 1 : 0}"
  name        = "${lookup(var.resource_tags, "Owner")}-${lookup(var.resource_tags, "env")}-${var.vpc_id}-service"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.public_service_port}"
    to_port     = "${var.public_service_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.service_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  public_subnet = "${var.public_subnet}"
  private_subnet = "${var.private_subnet}"
  public_instances = "${var.public_instances == -1 ? length(local.public_subnets) : var.public_instances}"
  private_instances = "${var.private_instances == -1 ? length(local.private_subnets) : var.private_instances}"
}

resource "aws_instance" "public_web" {
  count                = "${local.public_instances}"
  ami                  = "${data.aws_ami.ubuntu.id}"
  instance_type        = "${var.instance_type}"
  count                = "${var.count}"
  tags                 = "${var.resource_tags}"
  subnet_id            = "${element(local.public_subnet, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.aiip.name}"
  user_data = "${var.user_data}"

  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.service.id}"
  ]
}

resource "aws_instance" "private_web" {
  count                = "${local.private_instances}"
  ami                  = "${data.aws_ami.ubuntu.id}"
  instance_type        = "${var.instance_type}"
  tags                 = "${var.resource_tags}"
  subnet_id            = "${element(local.private_subnet, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.aiip.name}"
  user_data = "${var.user_data}"

  security_groups = [
    "${aws_security_group.ssh.id}",
  ]
}


# second run
# adding PR run to show TFE Plan
