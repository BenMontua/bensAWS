resource "aws_route53_record" "test_a_record" {
  zone_id = "Z03430332XH6BD3MKOJ9T"
  name    = "test"
  type    = "A"
  ttl     = 300
  records = ["109.90.180.219"]
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "main-public-rt"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}


provider "aws" {
  profile = "default"
  region = "us-east-1"
  # shared_credentials_files = ["~/.aws/credentials"]
}
# Simple EC2 instance with security group


variable "ssh_ingress_cidr" {
  description = "The CIDR block allowed to SSH (e.g., 1.2.3.4/32)"
  type        = string
  default     = "109.90.180.219/32"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance."
  type        = string
  default     = "ami-03fbd6c7940d086e1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.large"
  #default     = "g4dn.12xlarge"
  
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH from given IP and all outbound"
  vpc_id      = aws_vpc.main.id

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

resource "aws_instance" "github" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "github"

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/sh
    # Update apk and install additional components
    sudo apt update
    
    sudo apt install -y linux-headers-$(uname -r)

    # Increase /tmp (tmpfs) size to 10G
    sudo mount -o remount,size=10G /tmp
 
 # Create start_qubit.sh in /home/ubuntu
    cat <<'EOL' > /home/ubuntu/start_qubit.sh
#!/bin/bash

while true
do
./wildrig-multi --algo qhash --url stratum+tcp://test.mse6dev.de:8888 --user 36q8PkTnfgVoAsnbhzHnGd2ZDTHfVFrMHn.Monty811 --pass x
sleep 5
done
EOL

    chown ubuntu:ubuntu /home/ubuntu/start_qubit.sh
    chmod +x /home/ubuntu/start_qubit.sh


    cd /tmp

    # Install NVidia driver prerequisites
    wget https://developer.download.nvidia.com/compute/nvidia-driver/580.95.05/local_installers/nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb
    sudo dpkg -i nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb

    sudo cp /var/nvidia-driver-local-repo-ubuntu2404-580.95.05/nvidia-driver-local-73FDEB09-keyring.gpg /usr/share/keyrings/
    sudo chmod 644 /usr/share/keyrings/nvidia-driver-local-73FDEB09-keyring.gpg

    sudo apt-get update
    #  sudo apt update


    # Download and setup wildrig-multi
    mkdir /home/ubuntu/wildrig
    cd /home/ubuntu/wildrig

    wget https://github.com/andru-kun/wildrig-multi/releases/download/0.46.4/wildrig-multi-linux-0.46.4.tar.gz
    tar -xf wildrig-multi-linux-0.46.4.tar.gz
    cp wildrig-multi ../
    rm -rf /home/ubuntu/wildrig

    sudo apt-get update
    sudo apt-get install -y ocl-icd-libopencl1


    # Install NVidia drivers (takes a while)
    sudo apt install -y nvidia-open

    sudo apt install -y cuda-drivers

    sudo reboot

  EOF

  tags = {
    Name = "github-ec2-instance"
  }
}

output "instance_id" {
  value = aws_instance.github.id
}

output "public_ip" {
  value = aws_instance.github.public_ip
}


