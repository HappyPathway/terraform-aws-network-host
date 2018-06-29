output "sec_group" {
  value = "${aws_security_group.ssh.id}"
}

output "instances" {
  value = "${aws_instance.web.*.id}"
}

output "hosts" {
  value = "${aws_instance.web.*.public_ip}"
}

output "key_name" {
  value = "${data.terraform_remote_state.network.key_name}"
}
