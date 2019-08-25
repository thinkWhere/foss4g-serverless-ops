#!/usr/bin/env bash
# Setup global params.  Must be run prior negotiating with AWS
# Run as follows:
# . ./setenv.sh

# Override defaults if desired
REGION="us-east-1"
PROFILE="foss4g_ops"
BUCKET="foss4g-ops-tfstate"

# Add utils into path
export PATH=$PATH:`pwd`/utils

printf "#########################################################################\n"
printf "thinkWhere FOSS4G Serverless Ops\n\n"

# printf "Clean up Windows weirdness on utils ...\n\n"
dos2unix `pwd`/utils/tfinit
dos2unix  ~/.aws/credentials
dos2unix `pwd`/utils/parse_config.py

printf "\nSetting Tooling vars...\n"

export TF_VAR_region=$REGION
printf "\nTerraform AWS region:       $TF_VAR_region \n"

export TF_VAR_profile=$PROFILE
printf "Terraform Local profile:    $TF_VAR_profile \n"

export TF_VAR_bucket=$BUCKET
printf "Terraform Config S3 bucket: $TF_VAR_bucket \n"

# Set up AWS Default profile so we can use awscli commands
export AWS_DEFAULT_PROFILE=$PROFILE
printf "\nawscli default provider:    $TF_VAR_profile \n"

# Database admin passwords
DB_APPSSTAGING_PASS=`utils/parse_config.py $PROFILE db_appsstaging_pass`
export TF_VAR_db_appsstaging_pass=$DB_APPSSTAGING_PASS
printf "Terraform DB AppsStaging Pass   `echo $TF_VAR_db_appsstaging_pass | cut -c1-8`... \n\n"

printf "#########################################################################\n"

# push environment onto command line - so easy to see what we're using
# help is here https://www.digitalocean.com/community/tutorials/how-to-customize-your-bash-prompt-on-a-linux-vps
export PS1='\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \e[0;36m[$TF_VAR_profile]\n\[\033[00m\]\$ '
