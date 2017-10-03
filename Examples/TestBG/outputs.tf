output "elbaddress" {
  value = "${aws_elb.web.dns_name}"
}