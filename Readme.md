
# Connect 

ssh -i ~/.ssh/github.pem ubuntu@3.76.226.169



# get NVidia driver

# search for the right driver
https://developer.nvidia.com/datacenter-driver-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local


https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/




# Installation on Ubuntu 24.04

wget https://developer.download.nvidia.com/compute/nvidia-driver/580.95.05/local_installers/nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb
sudo dpkg -i nvidia-driver-local-repo-ubuntu2404-580.95.05_1.0-1_amd64.deb

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb





sudo apt-key del 73FDEB09

sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/73FDEB09.pub

sudo apt-get update



# CUDA Installer
wget https://developer.download.nvidia.com/compute/cuda/13.0.2/local_installers/cuda_13.0.2_580.95.05_linux.run
sudo sh cuda_13.0.2_580.95.05_linux.run