#
# Once complete, output the following data to the console
#

output "bastionaddress" {
  value = "${aws_instance.bastionhost.public_ip}"
  }
