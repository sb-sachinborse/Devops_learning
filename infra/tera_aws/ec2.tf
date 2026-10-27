#key pair (for login)
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("terra-ec2-key.pub")
}


#VPC 
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# security group

resource "aws_security_group" "terra-sg" {
    name = "automation_sg"
    description = "This is terraform generated sg"
    vpc_id = aws_default_vpc.default.id  # interpolation

    tags = {
      Name = "automation-sg"
    }

    # inbound rules
    ingress  {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
        description = "SSH open"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
        description = "Golang App"
    }
    # outbound rules
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All access outbounds."
    }

}

# ec2 instatne

resource "aws_instance" "terra_ec2" {
    key_name = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.terra-sg.name]
    instance_type = "t2.micro"
    ami = "ami-0cb91c7de36eed2cb" #ubuntu

    root_block_device {
      volume_size = 15
      volume_type = "gp3"
    }

    tags = {
      Name = "Terra-ec2-instance"
    }


}