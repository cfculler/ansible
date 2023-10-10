module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  count = 1
  name  = "carson-dob-7.3-tf"

  ami                    = "ami-0f8e81a3da6e2510a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-8507a5f8"]
  subnet_id              = "subnet-8e073cd5"

  tags = {
    Owner = "carson"
    Environment = "sandbox"
  }
}

output "ec2_public_ip" {
  value = module.ec2_instance.instances[0].public_ip
}

resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i localhost, -e 'ec2_public_ip=${module.ec2_instance.ec2_public_ip}' playbook.yml"
  }
}