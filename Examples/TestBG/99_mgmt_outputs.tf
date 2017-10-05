#
# Once complete, output the following data to the console
#

output "bastion_public_address" {
  value = "${aws_instance.bastionhost.public_ip}"
}

#output "artifactory_private_address" {
#  value = "${aws_instance.artifactoryhost.private_ip}"
#}

output "chef_private_address" {
  value = "${aws_instance.chefhost.private_ip}"
}

#output "chef_public_address" {
#  value = "${aws_instance.chefhost.public_ip}"
#}
