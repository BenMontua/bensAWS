# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Install required packages for console access
RUN apt-get update && \
    apt-get install -y \
        sudo \
        bash \
        locales \
        tzdata \
        vim \
        less \
        net-tools \
        iputils-ping \
        openssh-server

# Set up a user for console login
RUN useradd -ms /bin/bash devuser && \
    echo 'devuser:devpass' | chpasswd && \
    adduser devuser sudo

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Expose SSH port (optional, for remote SSH)
EXPOSE 22

# Start a bash shell by default
CMD ["bash"]
