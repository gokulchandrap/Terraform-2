#
# Use this to add any Application stations
#

resource "aws_instance" "greenweb1" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${aws_instance.greenweb1.private_ip}"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${data.aws_ami.ubuntu_xenial.id}"

  # The name of our SSH keypair we created above.
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id               = "${aws_subnet.default_green.id}"
  availability_zone       = "us-east-2a"
  tags{
    Name                  = "TT_Blue_Web1"
  }
  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
  tags {
    Name = "TT_Blue_Web1"
  }
}

resource "aws_instance" "greenweb2" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${aws_instance.greenweb2.private_ip}"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${data.aws_ami.ubuntu_xenial.id}"

  # The name of our SSH keypair we created above.
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id               = "${aws_subnet.default_green.id}"
  availability_zone       = "us-east-2a"
  tags{
    Name                  = "TT_Blue_Web2"
  }
  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update && sudo apt-get -y upgrade",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
  tags {
    Name = "TT_Blue_Web2"
  }
}
