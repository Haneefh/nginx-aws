# Grab the latest Ubuntu AMI #
data "aws_ami" "ec2-ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}


resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "awsvm" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.ec2-ami.id
  key_name                    = aws_key_pair.ec2_key.id
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pubsubnet.id
  vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]
  tags = {
    Name = "${var.name}_ec2"
  }
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = aws_instance.awsvm.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait for instance to accept ssh'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.awsvm.public_ip}, --private-key ${var.private_key_path} ansible/nginx.yml"
  }


}

