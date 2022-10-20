locals {
  #Feel free to change the fields below as your needs

 #############################
 # VPC Information           #
 #############################
  aws_region          = "us-east-1"
  vpc_name            = "challenge-vpc"
  vpc_cidr_block      = "172.21.0.0/16"


 #############################
 # Subnets information       #
 #############################
 # Remember to use valid CIDR blocks based on vpc_cidr_block
  public_subnet_name         = "challenge-public-subnet"
  public_subnet_cidr_block   = "172.21.0.0/24"
  public2_subnet_name         = "challenge-public2-subnet"
  public2_subnet_cidr_block   = "172.21.1.0/24"


 #############################
 # EC2 instance information  #
 #############################
  instance_name       = "challenge-instance"
  instance_type       = "t2.micro"
  volume_size         = 30
  # You can use your own public key here
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuh7W/0jIHBCth9xwMXq5SBMOlaqR3cs8XeoMl5vip/1hx7HhJ4/pGJqEaBB46kwmXVGb4FlZIFq/IA3K53Gioq08KhahPUkQdK5nPXzGNNpOo/A5RCB4tIqy0XCEl7NqsO2GPgF7TFdio1OftZJJ6O992gm8HRh6hJX9hxbyWN53IOhTmOMl65hf1vHRqpWDCojPjgKLcjls1Qo0hpZl6tOv0kJfyC/aTUZyU8g2IcrjORNvl4x8cRXt8eN/I/BiaQY5m5LlWLDVevZ1w9RNZMSaB7shvhmmIln1mTmMRBGYnuswf53SoXAD/sa7ywguZdrrzy9yNbiFBY1atKLqwtHdh1Ph9d2leVkhzLPKTVNxEYm8KUmUgI33zA7G5kmmUrm+xtj7ZkyNr6guw/QlZbuQ2dr+aYeIQeXd9sdcRdmSpOsqFbpJhPVefXOgbwRC0as/40gR8rgImTxyXZdeXGkHH0lo2/0y+sAcL+8n/u74gyUXQYPfH17VJ1gIJzdE="

 #############################
 # TAGS                      #
 #############################
  tags = {
    Terraform    = true
    Candidate     = "Evandro Aragao"
  }

}