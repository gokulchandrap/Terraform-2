# Some DNS in here so I don't have to change IPs all the time.

resource "aws_route53_record" "bastiondns" {
  zone_id = "Z2EEDGWKEZFB0S"
  name    = "bastion.jackaldefense.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.bastionhost.public_ip}"]
}
