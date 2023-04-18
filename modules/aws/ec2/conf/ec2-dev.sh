#!/bin/bash -xe
sudo bash -c 'exec > >( tee /var/log/user-data.log|logger -t user-data -s 2>/var/log/userdata.log ) 2>&1'
sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository --yes --update ppa:ansible/ansible &&
sudo apt install ansible  -y 
