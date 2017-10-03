# Access/Secret Keys
variable "aws_access_key"{
	description == "Paste the access key for the AWS account here"
}

variable "aws_secret_key"{
	description == "Paste the secret key for the AWS account here"
}

variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

}
