### create image danhnt/ansible:2.14.4 ###
FROM ubuntu:latest
LABEL MAINTAINER ynm

# Avoiding user interaction with tzdata when installing in a docker container.
ARG DEBIAN_FRONTEND=noninteractive

# Install ansible on ubuntu
RUN apt update -y && \
    apt install -y software-properties-common && \
    add-apt-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible && \
    # 'ssh' connection type with passwords, you must install the sshpass program
	apt install -y sshpass

# Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.
RUN echo '[defaults]\nhost_key_checking = false' > /etc/ansible/ansible.cfg

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]