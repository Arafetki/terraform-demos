resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Main"
  }

}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main igw"
  }
}


resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "default-rt"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }


  tags = {
    Name = "private-rt"
  }

}


resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private instances"
  }

}


resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public instances"
  }

}


resource "aws_security_group" "remote" {
  name        = "remote access"
  vpc_id      = aws_vpc.main.id
  description = "allow ssh traffic"
  ingress {
    description = "allow inbound traffic on port 22 from a list of ip adresses"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_address_list
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "remote-access-sg"
  }

}

resource "aws_security_group" "web" {
  name        = "web access"
  vpc_id      = aws_vpc.main.id
  description = "allow http and https traffic"
  ingress {
    description      = "allow inbound traffic on port 80 from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "allow inbound traffic on port 443 from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-access-sg"
  }

}


data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "demo" {
  key_name   = "demo_terraform"
  public_key = file(var.rsa_public_key)
}

resource "aws_instance" "demo_public" {
  subnet_id     = aws_subnet.public.id
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids      = [aws_security_group.remote.id, aws_security_group.web.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.demo.key_name

  # user_data = file(var.user_data)

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/arfoutk/learning/terraform/ssh_keys/demo_rsa")
  }

  provisioner "file" {
    source      = var.user_data
    destination = "/home/ubuntu/entrypoint.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/entrypoint.sh",
      "/home/ubuntu/entrypoint.sh",
      "exit"
    ]
  }

  tags = {
    Name = "public instance"
  }

}


resource "aws_instance" "demo_private" {
  subnet_id     = aws_subnet.private.id
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.remote.id]

  key_name = aws_key_pair.demo.key_name

  tags = {
    Name = "private instance"
  }

}