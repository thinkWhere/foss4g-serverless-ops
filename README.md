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

## Creating a Serverless Environment
This repo creates a serverless environment for 2 sample apps.  Instructions for working with the apps can be found in the project wiki, here:

https://github.com/thinkWhere/foss4g-serverless-ops/wiki

## A note on Security

Be aware that this repo creates an environment for demo purposes only.  Shortcuts have been taken to make apps easy to demo, in a production environment you will want to ensure you limit access to databases etc

