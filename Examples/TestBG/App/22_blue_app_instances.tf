#
# Use this to add any Application stations
#

resource "aws_instance" "blueweb1" {
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${aws_instance.blueweb1.private_ip}"
  }
  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default_blue.id}"
  availability_zone       = "us-east-2a"
  tags{
    Name                  = "TT_Blue_Web1"
  }

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

resource "aws_instance" "blueweb2" {
  connection {
    user = "ubuntu"
    host = "${aws_instance.blueweb2.private_ip}"
  }
  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default_blue.id}"
  availability_zone       = "us-east-2a"
  tags{
    Name                  = "TT_Blue_Web2"
  }

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
