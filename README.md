# Challenge SRE Cloud

This repo contains all files needed to deploy my version of the challenge.

All the infrastructure will be deployed to AWS using Terraform. There are also an ansible script which configures the EC2 instance, build and deploy the golang application to a docker container.

The terraform code creates basically:
- VPC, Subnets, Security Groups and Internet Gateway.
- EC2 Instance to run the application docker container.
- Application Load Balancer to allow us to use the Cloudfront as webproxy.
- Cloudfront distribution as HTTP/HTTPS proxy.

To get instructions about how to deploy the code or what resources will be created in your AWS account, please read [this file.](https://github.com/evandroaragao/challenge-sre-cloud/blob/main/terraform/README.md)

__Attention: The SSH keys stored in this repository were created for testing purposes only. NEVER use them in a production environment.__
