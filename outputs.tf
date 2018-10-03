output "sec_group" {
  value = "${aws_security_group.ssh.id}"
}

output "instances" {
  value = "${aws_instance.web.*.id}"
}

output "private_hosts" {
  value = "${aws_instance.private_web.*.private_ip}"
}

output "public_hosts" {
  value = "${aws_instance.public_web.*.public_ip}"
}

output "key_name" {
  value = "${data.terraform_remote_state.network.key_name}"
}
