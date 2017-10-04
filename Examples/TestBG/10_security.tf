#
# Use this as a firewall. Note that NACL is stateless and Security Groups are stateful.
#

# Add a NACL
resource "aws_network_acl" "defaultnacl" {
  vpc_id = "${aws_vpc.default.id}"
  tags{
    name  = "Default_NACL"
  }
}

# Add an allow all NACL Ingress rule
resource "aws_network_acl_rule" "aaingress" {
  network_acl_id = "${aws_network_acl.defaultnacl.id}"
  rule_number    = 200
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "aaegress" {
  network_acl_id = "${aws_network_acl.defaultnacl.id}"
  rule_number    = 200
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

#SECURITY GROUPS
# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "Default_SG"
  description = "The Default Security Group"
  vpc_id      = "${aws_vpc.default.id}"

  # Anything from Home
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["68.40.189.0/24"]
  }

  # Anything from Work
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["50.224.85.2/32"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTPS access from the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Anything from The Management Network
  ingress {
  	from_port   = 0
  	to_port     = 0
  	protocol    = -1
  	cidr_blocks = ["10.0.3.0/24"]
    }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags{
    Name  = "Default_SG"
  }
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elbsg" {
  name        = "ELB_SG"
  description = "Used for the ELB responsible for loadbalancing Blue and Green"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Anything from The Management Network
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["10.0.3.0/24"]
  }

  # Anything from Home
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["68.40.189.0/24"]
  }

  # Anything from Work
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["50.224.85.2/32"]
  }
  tags{
    Name  = "ELB_SG"
  }
}

resource "aws_security_group" "bastionsg" {
  name        = "Bastion_SG"
  description = "Used for only the bastion host"
  vpc_id      = "${aws_vpc.default.id}"

  # Anything from Home
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["68.40.189.0/24"]
  }

  # Anything from Work
  ingress {
  	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["50.224.85.2/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags{
    Name  = "Bastion_SG"
  }
}

resource "aws_security_group" "artifactorysg" {
  name        = "Artifactory_SG"
  description = "Used for the Artifactory host"
  vpc_id      = "${aws_vpc.default.id}"

  # Anything from Home
  ingress {
	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["68.40.189.0/24"]
  }

  # Anything from Work
  ingress {
	from_port   = 0
	to_port     = 0
	protocol    = -1
	cidr_blocks = ["50.224.85.2/32"]
  }

  # Allow BLUE/GREEN to hit artifactory ports
  ingress {
    from_port = 8080
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/23"]
  }

  ingress {
    from_port = 8080
    to_port = 8081
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/23"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags{
    Name  = "Artifactory_SG"
  }
}
