## How to deploy the code

* Clone the repository to your computer.
* Configure your <code>AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY</code> local variables.
* All the inputs are configured in <code>main.tf</code> file as locals. You can use the default values or change them as your needs. 
<br>(__IMPORTANT__): If you choose to use your own SSH keys, you must save the private key on <code>/terraform</code> folder and rename it to <code>challenge-key.pem</code>.</br>
* Navigate to the terraform folder and run the terraform init command.<pre><code>terraform init</code></pre>
* Run terraform apply command to deploy the resources.<pre><code>terraform apply</code></pre>
* After all resources been deployed, you will receive outputs. Copy the URL of the <code>Cloudfront Distribution Domain Name</code>. __This will be the URL to access the web application via HTTP and HTTPS, as requested by the challenge.__


## How to update the binary

* Access the EC2 instance via SSH. To do that, follow these steps:
  1. Get the IP Address in the output <code>Instance public IP</code>
  2. Navigate to <code>terraform</code> folder
  3. Run the following command changing "IP-ADDRESS" by the instance's public IP. <pre><code>ssh -i challenge-key.pem ec2-user@"IP-ADDRESS" -p 22022</code></pre>
  4. Create a new version of your <code>main.go</code> file.
  5. Run the following script to build and deploy a new container with your new code. <pre><code>sudo /application/update_binary.sh</code></pre>
  6. Validate the application by accessing the <code>Cloudfront Distribution Domain Name</code> that you have taken in the terraform outputs.


## How to revert the application to the original state
* Access the EC2 instance via SSH. To do that, follow these steps:
  1. Get the IP Address in the output <code>Instance public IP</code>
  2. Navigate to <code>terraform</code> folder
  3. Run the following command changing "IP-ADDRESS" by the instance's public IP. <pre><code>ssh -i challenge-key.pem ec2-user@"IP-ADDRESS" -p 22022</code></pre>
  4. Run this command to stop and delete the current docker container. <pre><code>sudo docker rm $(sudo docker stop $(sudo docker ps -a -q --filter name=challenge-app --format="{{.ID}}"))</code></pre>
  5. Run this Ansible playbook to redeploy the first version of the application. <pre><code>sudo ansible-playbook /ansible-playbooks/playbook.yml</code></pre>
  6. Validate the application by accessing the <code>Cloudfront Distribution Domain Name</code> that you have taken in the terraform outputs.



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.35.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cf](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/cloudfront_distribution) | resource |
| [aws_default_route_table.default_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/default_route_table) | resource |
| [aws_default_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/default_security_group) | resource |
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/key_pair) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/lb) | resource |
| [aws_lb_listener.front_end](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_route_table_association.public_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/route_table_association) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/security_group) | resource |
| [aws_security_group.ec2_instance_ec2](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.ec2_ssh](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/subnet) | resource |
| [aws_subnet.public2](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/resources/vpc) | resource |
| [null_resource.ansible_playbooks](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.amazonlinux](https://registry.terraform.io/providers/hashicorp/aws/4.35.0/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The default VPC security group ID |
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | Cloudfront Distribution ARN |
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | Cloudfront Distribution ID |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Cloudfront Distribution Domain Name |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Instance ID |
| <a name="output_instance_type"></a> [instance\_type](#output\_instance\_type) | Instance type |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Instance private IP |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Instance public IP |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | EC2 Instance's Security Group ARN |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | EC2 Instance's Security Group ID |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | Security group associated to EC2 Instance |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | VPC ARN |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | VPC CIDR block |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
