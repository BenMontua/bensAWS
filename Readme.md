
# Connect 

ssh -i ~/.ssh/github.pem ubuntu@34.229.7.157

# Docker

docker build -t qubit-ha-proxy .
docker run -d -p 8888:8888 qubit-ha-proxy

curl -v http://qubitcoin.luckypool.io:8611


curl ipinfo.io/ip


# get NVidia driver

# search for the right driver
https://developer.nvidia.com/datacenter-driver-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local


https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/


# Installation on Ubuntu 24.04

wget https://developer.download.nvidia.com/compute/nvidia-driver/580.95.05/local_installers/nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb
sudo dpkg -i nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb

sudo cp /var/nvidia-driver-local-repo-ubuntu2404-580.95.05/nvidia-driver-local-73FDEB09-keyring.gpg /usr/share/keyrings/
sudo chmod 644 /usr/share/keyrings/nvidia-driver-local-73FDEB09-keyring.gpg

sudo apt-get update
sudo apt update

sudo apt install -y nvidia-open

sudo apt install -y cuda-drivers

# NVidia driver version

modinfo nvidia | grep ^version

# only if card is present?
nvidia-smi


# Wildrig Miner

mkdir wildrig
cd wildrig

wget https://github.com/andru-kun/wildrig-multi/releases/download/0.46.4/wildrig-multi-linux-0.46.4.tar.gz
tar -xf wildrig-multi-linux-0.46.4.tar.gz

sudo apt-get update
sudo apt-get install -y ocl-icd-libopencl1