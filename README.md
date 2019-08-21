# foss4g-serverless-ops
Repo containing Terraform scripts for spinning up AWS serverless environment

## First Run Config
Before we run for the first time we need to do a small amount of setup explained on this wiki page - [First Run Config](https://github.com/thinkWhere/foss4g-serverless-ops/wiki/First-Run-Config) 

## Running the Container
The container can be run as follows, once logged in you MUST run the ```setenv.sh``` to ensure environment is set up correctly

```bash
docker-compose run foss4g-ops
cd ops
. ./setenv.sh
```

## TODO

* First Run Config
    * Set up a Terraform Admin User
    * Setup an S3 bucket to hold Terraform State
* Docker-compose and setenv.sh
* Explain Terraform modules/registry
* Create VPC