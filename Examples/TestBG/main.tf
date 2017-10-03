# Specify the provider and details
provider "aws" {
  region     = "us-east-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

#Identify most recent Xenial 16.04 build
data "aws_ami" "ubuntu_xenial" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
  	Name = "DefaultVPC"
  }
}

# Add a NACL
resource "aws_network_acl" "defaultnacl" {
  vpc_id = "${aws_vpc.default.id}"
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

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "defaultigw" {
  vpc_id = "${aws_vpc.default.id}"
}

# Add a default route to the main route table
resource "aws_route" "default_route" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.defaultigw.id}"
}

# Create the BLUE
resource "aws_subnet" "default_blue" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# Create the GREEN subnet
resource "aws_subnet" "default_green" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

# Create the MANAGEMENT subnet
resource "aws_subnet" "default_mgmt" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2c"
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elbsg" {
  name        = "terratest_elb"
  description = "Used for loadbalancing Blue and Green"
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
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
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

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = ["${aws_subnet.default_blue.id}", "${aws_subnet.default_green.id}"]
  security_groups = ["${aws_security_group.elbsg.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  } 
}

#resource "aws_key_pair" "terratesting" {
#  key_name   = "TerraTesting"
#  public_key = "D:\\Libraries\\Pyralix\\Documents\\GitHub\\Private_Resources\\TerraTesting-us-east-2-putty.pem"
#}

resource "aws_instance" "bastion" {
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
  ami = "${data.aws_ami.ubuntu_xenial.id}"

  # The name of our SSH keypair we created above.
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id               = "${aws_subnet.default_mgmt.id}"
  availability_zone       = "us-east-2c"

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
