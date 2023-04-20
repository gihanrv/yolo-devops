# DevOps / SRE Task

# This repository contains a slution for follwing tasks

* Deploy follwing service on AWS using IaaC Terrom and Terrgrunt
  - VPC 10.161.0.0/24.
  - 3 Subnets: 1 per availability zone.
  - 3 EC2 instances.
  - ALB serving port 80 on each instance.

* Deploy and Confiure follwing service using ansible roles
  -  Deploy and configure an Nginx Docker container on each EC2 instance.
  - Each nginx instance must have a different index.html (e.g. Hello, server1; Hello, server2; Hello, server3)

### Terraform, Terragrunt, and Ansible

* Terraform is an open-source infrastructure-as-code (IAC) tool created by HashiCorp. It allows you to define and manage infrastructure resources in a declarative manner, meaning you can specify the desired state of your infrastructure and Terraform will take care of creating and updating the necessary resources to reach that state. Terraform supports multiple cloud providers, such as Amazon Web Services, Microsoft Azure, Google Cloud Platform, and more. It also has a large community of users and contributors, which provides a wide range of plugins and modules to extend its functionality.

* Terragrunt is a thin wrapper for Terraform that provides extra functionality to manage multiple Terraform modules and environments. It simplifies the workflow for managing infrastructure code by enabling you to create reusable modules, set variables, and manage state across multiple environments. Terragrunt supports best practices for infrastructure code, such as remote state storage, locking, and versioning. It also has a command-line interface that simplifies complex tasks, like managing multiple Terraform modules at once.


* Ansible is an open-source automation tool that allows you to configure and manage systems, applications, and networks. It uses a simple, declarative language to describe tasks, making it easy to understand and use.
Ansible works by running tasks on remote hosts over SSH, making it agentless and easy to set up. It also supports multiple operating systems and cloud providers, and has a large community of users and contributors.



## Getting Started
1. Clone the repository to your local machine using the following command:
```
   git clone https://github.com/gihanrv/yolo-devops.git
```

### Prerequisites

### You must have aws cli access before executes install.sh 

2. Change following varible names in [env.hcl](yolo-dev-use1/env.hcl) file base on your aws accouts settings
```
  - aws_region : default  = "us-east-1"
  - aws_region_short : default = "use1"
  - aws_profile : default = "default"
  - aws_account_id (Optional) 
  
* terrfrom : if you don't have it will install latest version when run install.sh
* terrgrunt if you don't have it will install latest version when run install.sh
```
### Installation
3. Run install.sh shell script 
```
chmod 775 install.sh && ./install.sh
```
* this ishcript will do 
  - install terrform and terragrunt
  - move to [yolo-dev-use1](yolo-dev-use1) folder and run "terragrunt run-all apply"  (auto approve create backend s3 and terragrunt apply)

