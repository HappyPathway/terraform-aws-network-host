output "sec_group" {
  value = "${aws_security_group.ssh.id}"
}

output "instances" {
  value = "${aws_instance.web.*.id}"
}

output "hosts" {
  value = "${aws_instance.web.*.public_ip}"
}
