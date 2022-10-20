#Filter amazonlinux ami
data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

#Create aws key pair
resource "aws_key_pair" "deployer" {
  key_name   = "${local.instance_name}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuh7W/0jIHBCth9xwMXq5SBMOlaqR3cs8XeoMl5vip/1hx7HhJ4/pGJqEaBB46kwmXVGb4FlZIFq/IA3K53Gioq08KhahPUkQdK5nPXzGNNpOo/A5RCB4tIqy0XCEl7NqsO2GPgF7TFdio1OftZJJ6O992gm8HRh6hJX9hxbyWN53IOhTmOMl65hf1vHRqpWDCojPjgKLcjls1Qo0hpZl6tOv0kJfyC/aTUZyU8g2IcrjORNvl4x8cRXt8eN/I/BiaQY5m5LlWLDVevZ1w9RNZMSaB7shvhmmIln1mTmMRBGYnuswf53SoXAD/sa7ywguZdrrzy9yNbiFBY1atKLqwtHdh1Ph9d2leVkhzLPKTVNxEYm8KUmUgI33zA7G5kmmUrm+xtj7ZkyNr6guw/QlZbuQ2dr+aYeIQeXd9sdcRdmSpOsqFbpJhPVefXOgbwRC0as/40gR8rgImTxyXZdeXGkHH0lo2/0y+sAcL+8n/u74gyUXQYPfH17VJ1gIJzdE="
}

#AWS Instance
resource "aws_instance" "instance" {
  depends_on = [
    aws_security_group.ec2_instance_ec2,
    aws_vpc.main,
    aws_key_pair.deployer
  ]

  ami                         = data.aws_ami.amazonlinux.id
  instance_type               = local.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2_instance_ec2.id]
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.deployer.key_name

#This user_data script install ansible and change ssh port to 22022
  user_data           = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
sudo perl -pi -e 's/^#?Port 22$/Port 22022/' /etc/ssh/sshd_config
sudo service sshd restart || service ssh restart
  EOF

#Configure root volume
  root_block_device {
    volume_size = local.volume_size
    tags                 = merge(local.tags, { Name = local.instance_name })
  }

  tags                 = merge(local.tags, { Name = local.instance_name })
}

#Execute ansible playbooks on the host
resource "null_resource" "ansible_playbooks" {
  depends_on = [aws_instance.instance]
  connection {
    type        = "ssh"
    host        = aws_instance.instance.public_ip
    user        = "ec2-user"
    port        = 22022
    private_key = "${file("challenge-key.pem")}"
    timeout     = "5m"
  }
  provisioner "file" {
    source      = "../ansible"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "sudo mkdir /ansible-playbooks",
      "sudo mkdir /application",
      "sudo cp -R /tmp/ansible/* /ansible-playbooks",
      "sudo cp -R /ansible-playbooks/application/* /application",
      "sudo chmod -R +rx /ansible-playbooks",
      "sudo chmod -R +rwx /application",
      "sudo ansible-playbook /ansible-playbooks/playbook.yml"
    ]
  }
}