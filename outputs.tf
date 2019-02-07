output "sec_group" {
  value = "${aws_security_group.ssh.id}"
}

output "instances" {
  value = "${aws_instance.instance.*.id}"
}

output "hosts" {
  value = "${aws_instance.instance.*.private_ip}"
}

output "role" {
  value = "${var.organization}-${lookup(var.resource_tags, "env")}"
}
