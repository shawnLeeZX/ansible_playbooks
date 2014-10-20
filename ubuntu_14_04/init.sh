#!/bin/bash

usage()
{
    printf "%b" "
Usage:
init.sh will do ubuntu 14.04 setup automatically. All you need to input is your
user name.

bash init.sh USER_NAME
"
}

if [ $# -ne 1 ]
then
    usage
    exit 0
fi

USER_NAME=$1

# Clean up home folder.
cd
rmdir  Desktop Documents Music Pictures Public Templates Videos

# Install necessary softwares.
sudo apt-get -y install tmux git vim
sudo apt-get -y install python-pip
sudo pip install paramiko PyYAML jinja2 httplib2
sudo apt-get -y install openssh-server

# Varaibles.
ROOT_FOLDER="$HOME/mine"
SOFTWARE_FOLDER="${ROOT_FOLDER}/softwares"

# Setup directory structure.
mkdir -p ${SOFTWARE_FOLDER}

# Setup ansible
git clone git://github.com/ansible/ansible.git ${SOFTWARE_FOLDER}/ansible --recursive
git clone https://github.com/shawnLeeZX/ansible_playbooks ${SOFTWARE_FOLDER}/playbooks

# Setup ssh.
cd
echo -e 'y\n' |  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh-add
ssh 127.0.0.1

PLAYBOOK_HOME="${SOFTWARE_FOLDER}/playbooks/ubuntu_14_04"

source ${SOFTWARE_FOLDER}/ansible/hacking/env-setup

# Run playbooks.
ansible-playbook "${PLAYBOOK_HOME}/site.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"

# Install octopress.
ansible-playbook "${PLAYBOOK_HOME}/octopress.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"

# Install emacs.
ansible-playbook "${PLAYBOOK_HOME}/emacs.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"

# Install sklearn.
ansible-playbook "${PLAYBOOK_HOME}/scikit.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"

# Install R.
ansible-playbook "${PLAYBOOK_HOME}/R.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"

# Install ipython
ansible-playbook "${PLAYBOOK_HOME}/ipython.yml" \
    -i "${PLAYBOOK_HOME}/hosts" -K \
    --extra-vars "hosts=local_machine user=$USER_NAME"
