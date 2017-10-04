#
# Use this to define network environment
#

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
  	Name = "TT_Default_VPC"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "defaultigw" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "defaultIGW"
  }
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
  tags {
    Name  = "10_TT_BLUE_Subnet"
  }
}

# Create the GREEN subnet
resource "aws_subnet" "default_green" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
  tags {
    Name  = "20_TT_GREEN_Subnet"
  }
}

# Create the MANAGEMENT subnet
resource "aws_subnet" "default_mgmt" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2c"
  tags {
    Name  = "00_TT_MGMT_Subnet"
  }
}
