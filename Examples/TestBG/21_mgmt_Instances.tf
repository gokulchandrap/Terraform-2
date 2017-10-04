#
# Use this to add any management stations
#

resource "aws_instance" "bastionhost" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  #connection {
  #  # The default username for our AMI
  #  user = "ubuntu"
  #
  #  # The connection will use the local SSH agent for authentication.
  #}

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "ami-9bf4d9fe"

  # The name of our SSH keypair we created above.
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.bastionsg.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id               = "${aws_subnet.default_mgmt.id}"
  availability_zone       = "us-east-2c"
  tags{
    Name                  = "BastionHost"
  }
  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt-get -y update",
  #    "sudo apt-get -y install nginx",
  #    "sudo service nginx start",
  #  ]
  #}
}
