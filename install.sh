#!/bin/bash

if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'macOS'
  brew install terragrunt
fi

function terraform-install() {
echo "Checking Terraform . . ."
  [[ -f ${HOME}/bin/terraform ]] && echo "`${HOME}/bin/terraform version` already installed at ${HOME}/bin/terraform" && return 0

    LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)

      curl ${LATEST_URL} > /tmp/terraform.zip
        mkdir -p ${HOME}/bin
	  (cd ${HOME}/bin && unzip /tmp/terraform.zip)
	    if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc) ]]; then
		      	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
			  fi

			    echo "Installed: `${HOME}/bin/terraform version`"

		    }


function terragrunt-install() {
echo "Checking Terragrunt . . ."
	[[ -f ${HOME}/bin/terragrunt ]] && echo "Terragrunt `${HOME}/bin/terragrunt | grep -iA 2 version | tr -d '\n'` already installed at ${HOME}/bin/terragrunt" && return 0

	LATEST_URL=$(curl -sL  https://api.github.com/repos/gruntwork-io/terragrunt/releases  | jq -r '.[0].assets[].browser_download_url' | egrep 'linux.*amd64' | tail -1)
		mkdir -p ${HOME}/bin
		curl -sL ${LATEST_URL} > ${HOME}/bin/terragrunt
		chmod +x ${HOME}/bin/terragrunt

			        if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc) ]]; then
					  	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
						  fi

						    echo "Installed: Terragrunt `${HOME}/bin/terragrunt | grep -iA 2 version | tr -d '\n'`"
					    }

					    terraform-install
					    terragrunt-install


alias brc='source ~/.bashrc'
cd yolo-dev-use1/
echo -e "\n This will run terragrunt run-all apply and pass 'y' for create backend S3 bucket and apply changes"
terragrunt run-all apply
