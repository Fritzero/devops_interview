resource "aws_security_group" "webserver" {
  name        = "allow_http_https"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "icmp" {
  name        = "allow_ping"
  description = "Allow ICMP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "google" {
  name        = "allow_google"
  description = "Allow Google traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["104.154.0.0/15"]
  }
}

resource "aws_security_group" "internal" {
  name        = "allow_tcp_udp_vpc"
  description = "Allow tcp and udp in the vpc"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "tcp"
    cidr_blocks = [local.cidr]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "udp"
    cidr_blocks = [local.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
