#### VPC ID ####
output "vpc_id" {
  value = aws_vpc.main.id
}


output "ec2_public_ip" {
  value = aws_instance.awsvm.public_ip
}