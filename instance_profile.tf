data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "aipd" {
  statement {
    sid       = "AllowSelfAssembly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeTags",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole",
    ]
  }
}

resource "aws_iam_role" "air" {
  name               = "${var.organization}-${lookup(var.resource_tags, "Role")}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "airp" {
  name   = "${var.organization}-${lookup(var.resource_tags, "Role")}"
  role   = "${aws_iam_role.air.id}"
  policy = "${data.aws_iam_policy_document.aipd.json}"
}

resource "aws_iam_instance_profile" "aiip" {
  name = "${var.organization}-${lookup(var.resource_tags, "Role")}"
  role = "${aws_iam_role.air.name}"
}
