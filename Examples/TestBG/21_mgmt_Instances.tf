#
# Use this to add any management stations
#

resource "aws_instance" "bastionhost" {
  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastionsg.id}"]
  subnet_id               = "${aws_subnet.default_mgmt.id}"
  availability_zone       = "us-east-2c"
  tags{
    Name                  = "BastionHost"
  }

}
