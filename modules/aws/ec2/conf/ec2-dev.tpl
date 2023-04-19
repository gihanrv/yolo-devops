#!/bin/bash 
set -e 
sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository --yes --update ppa:ansible/ansible &&
sudo apt install ansible  -y
sudo mkdir -p /tmp/${git_repo_name} && sudo git clone -b ${git_branch} ${git_repo_url} /tmp/${git_repo_name}
cd /tmp/${git_repo_name}/modules/ansible/
ansible-playbook deployment.yaml -e stack=${stack} -e message=${message}

sudo "cat /var/log/user-data.log | tee /dev/tty | tee >(logger -t user-data)"