data "terraform_remote_state" "network" {
  backend = "atlas"

  config {
    name = "${var.organization}/${var.network_ws}"
  }
}

provider "aws" {
  region = "${data.terraform_remote_state.network.region}"
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
  name        = "${lookup(var.resource_tags, "Owner")}-${lookup(var.resource_tags, "Role")}-${data.terraform_remote_state.network.vpc_id}"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.terraform_remote_state.network.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  count         = "${var.count}"
  tags          = "${var.resource_tags}"
  subnet_id     = "${data.terraform_remote_state.network.public_subnet}"
  key_name      = "${data.terraform_remote_state.network.key_name}"
  user_data     = "${var.user_data}"

  security_groups = [
    "${data.terraform_remote_state.network.admin_sg}",
    "${aws_security_group.ssh.id}",
  ]
}
