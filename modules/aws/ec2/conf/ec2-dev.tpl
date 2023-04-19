#!/bin/bash 
set -e 
sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository --yes --update ppa:ansible/ansible &&
sudo apt install ansible  -y >> /var/log/user-data.log
sudo mkdir -p /tmp/${git_repo_name} && sudo git clone -b ${git_branch} ${git_repo_url} /tmp/${git_repo_name} >> /var/log/user-data.log
cd /tmp/${git_repo_name}/modules/ansible/
sudo ansible-playbook deployment.yaml -e stack=${stack} -e message=${server_name} -e instance_id=${server_name} -e cloudwatch_log_group=${cloudwatch_log_group} -e log_file_path=${log_file_path} -v >> /var/log/user-data.log 2>&1

sudo "cat /var/log/user-data.log | tee /dev/tty | tee >(logger -t user-data)"