

# Simple EC2 instance with security group

variable "vpc_id" {
  description = "The VPC ID to launch the instance in."
  type        = string
  default     = "vpc-xxxxxxxx"
}

variable "subnet_id" {
  description = "The Subnet ID to launch the instance in."
  type        = string
  default     = "subnet-xxxxxxxx"
}

variable "ssh_ingress_cidr" {
  description = "The CIDR block allowed to SSH (e.g., 1.2.3.4/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance."
  type        = string
  default     = "ami-xxxxxxxx"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH from given IP and all outbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from given IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "example-ec2-instance"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}


