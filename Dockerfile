# Create docker container with Terraform installed, and suite of tools to ease working with AWS
FROM ubuntu:19.04

ENV TERRAFORM_VERSION 0.12.6
ENV TERRAFORM_URL https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install dependencies
RUN apt-get update && apt-get install -y \
    dos2unix \
    curl \
    git-core \
    python3-pip \
    vim \
    zip

# Set python aliases for python3 and upgrade pip
RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc
RUN pip3 install --upgrade pip

# Install python dependencies
RUN pip3 install awscli

# Install Terraform
RUN curl -o /root/terraform.zip $TERRAFORM_URL && \
   unzip /root/terraform.zip -d /usr/local/bin/ && \
   rm /root/terraform.zip
