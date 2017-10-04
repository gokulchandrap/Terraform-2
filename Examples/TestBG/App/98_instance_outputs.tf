#
# Once complete, output the following data to the console
#

  output "address" {
    value = "${aws_elb.webelb.dns_name}"
  }
