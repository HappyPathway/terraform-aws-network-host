output "sec_group" {
  value = "${aws_security_group.ssh.id}"
}

output "private_instances" {
  value = "${aws_instance.private_web.*.id}"
}

output "public_instances" {
  value = "${aws_instance.public_web.*.id}"
}


output "private_hosts" {
  value = "${aws_instance.private_web.*.private_ip}"
}

output "public_hosts" {
  value = "${aws_instance.public_web.*.public_ip}"
}

output "role" {
  value = "${var.organization}-${lookup(var.resource_tags, "env")}"
}
