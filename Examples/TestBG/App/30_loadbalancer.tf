resource "aws_elb" "webelb" {
  name = "YellowELB"

  subnets         = ["${aws_subnet.default_blue.id}", "${aws_subnet.default_green.id}"]
  security_groups = ["${aws_security_group.elbsg.id}"]
  instances       = ["${aws_instance.blueweb1.id}", "${aws_instance.blueweb2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags {
    Name = "Yellow_ELB"
  }
}
