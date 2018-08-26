resource "aws_security_group" "app" {
  name = "chess_app"
  description = "my chess app sg"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0 
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_instance" "app" {
  ami           = "ami-6cd6f714"
  instance_type = "t2.nano"
  key_name = "${var.keyname}"
  security_groups = ["${aws_security_group.app.name}"]

  provisioner "remote-exec" {

  inline = [
    "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
    "sudo yum update -y",
    "sudo yum install git -y",
    "sudo yum install nginx -y",
    "git clone https://github.com/TheRedWizard/portfolio.git",
    "sudo rm -rf /usr/share/nginx/html/*",
    "sudo cp -R /home/ec2-user/portfolio/chess/client/src/* /usr/share/nginx/html/",
    "sudo systemctl start nginx",
  ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("/Users/ericcrook/pems/eric-dev.pem")}"
    }
  }
}
