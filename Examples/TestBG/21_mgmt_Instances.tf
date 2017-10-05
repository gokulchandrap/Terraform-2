#
# Use this to add any management stations
#

# Removed as this will be a static management server. Pet not Cattle.

resource "aws_instance" "bastionhost" {
  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastionsg.id}"]
  subnet_id               = "${aws_subnet.default_mgmt.id}"
  availability_zone       = "us-east-2c"
  tags{
    Name                  = "TT_MGMT_00_Bastion"
  }

}

#resource "aws_instance" "artifactoryhost" {
#  instance_type = "t2.micro"
#  ami = "${data.aws_ami.ubuntu_xenial.id}"
#  key_name = "${var.key_name}"
#  vpc_security_group_ids = ["${aws_security_group.artifactorysg.id}"]
#  subnet_id               = "${aws_subnet.default_mgmt.id}"
#  availability_zone       = "us-east-2c"
#  associate_public_ip_address = "false"
#  tags{
#    Name                  = "TT_MGMT_10_Artifactory"
#  }
#
#}

resource "aws_instance" "chefhost" {
  instance_type = "t2.micro"
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.chefsg.id}"]
  subnet_id               = "${aws_subnet.default_mgmt.id}"
  availability_zone       = "us-east-2c"
  associate_public_ip_address = "false"
  tags{
    Name                  = "TT_MGMT_20_Chef"
  }

}
