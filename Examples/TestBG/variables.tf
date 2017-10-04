#
# Define variables here
#

# Access/Secret Keys
variable "aws_access_key"{}

variable "aws_secret_key"{}

variable "key_name" {
	default = "TerraTesting"
}

variable "aws_region" {
	default = "us-east-2"
}
