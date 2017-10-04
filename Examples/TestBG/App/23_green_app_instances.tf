#
# Use this to add any Application stations
#

resource "aws_instance" "greenweb1" {
  connection {
    user = "ubuntu"
    host = "${aws_instance.greenweb1.private_ip}"
  }

  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default_green.id}"
  availability_zone       = "us-east-2b"
  tags{
    Name                  = "TT_Green_Web1"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
  tags {
    Name = "TT_Green_Web1"
  }
}

resource "aws_instance" "greenweb2" {
  connection {
    user = "ubuntu"
    host = "${aws_instance.greenweb2.private_ip}"
  }

  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default_green.id}"
  availability_zone       = "us-east-2b"
  tags{
    Name                  = "TT_Green_Web2"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update && sudo apt-get -y upgrade",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
  tags {
    Name = "TT_Green_Web2"
  }
}
