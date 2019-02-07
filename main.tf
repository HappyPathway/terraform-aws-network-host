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

resource "aws_instance" "instance" {
  count                = "${var.instances}"
  ami                  = "${data.aws_ami.ubuntu.id}"
  instance_type        = "${var.instance_type}"
  tags                 = "${var.resource_tags}"
  subnet_id            = "${var.subnet_id}"
  iam_instance_profile = "${aws_iam_instance_profile.aiip.name}"
  user_data = "${var.user_data}"
  key_name = "${var.key_name}"
  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.service.id}"
  ]
}

