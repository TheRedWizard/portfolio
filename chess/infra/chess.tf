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

  provisioner "file" {
    source = "client/src/index.html"
    destination = "/tmp/index.html"
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("/Users/ericcrook/pems/eric-dev.pem")}"
    }
  }


  provisioner "remote-exec" {

  inline = [
    "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
    "sudo yum update -y",
    "sudo yum install git -y",
    "sudo yum install nginx -y",
    "sudo systemctl start nginx",
    "sudo rm -rf /usr/share/nginx/html/*",
    "sudo cp /tmp/index.html /usr/share/nginx/html/index.html"
  ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("/Users/ericcrook/pems/eric-dev.pem")}"
    }
  }
}
