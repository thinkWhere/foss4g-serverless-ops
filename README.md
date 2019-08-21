# foss4g-serverless-ops
Repo containing Terraform scripts for spinning up AWS serverless environment

#### Running the Container
The container can be run as follows, once logged in you MUST run the ```setenv.sh``` to ensure environment is set up correctly

```bash
docker-compose run foss4g-ops
cd ops
. ./setenv.sh
```

## TODO

* Explain setting up AWS credentials
* Setup an S3 bucket to hold Terraform State