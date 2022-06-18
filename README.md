# Automated Nginx setup on AWS using  Docker

# Project Summary
This builds an AWS Infrastructure with networking and compute instance using terraform.
Ansible is integrated to deploy a nginx docker container on the instance

## Requirements
Terraform version 1 or above\
Ansible version 2.9 or above\
Community Docker installed (can be done using below command)
```bash
ansible-galaxy collection install community.docker
````

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.19.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 2.2.0 |

## Usage
1. Clone the github repository
2. Change terraform.tfvars.example to terraform.tfvars and provide the variable values.
3. Run the below to initialize terraform 
   ``` bash
   terraform init
   ````
4. Run a plan followed by an apply
   ``` bash
   terraform plan 
   terraform apply
   ````

## Resources

| Name | Type |
|------|------|
| [aws_instance.awsvm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.ec2_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route.default_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_http_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.pubsubnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.ec2-ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [http_http.my_public_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_dns_hostnames"></a> [dns\_hostnames](#input\_dns\_hostnames) | n/a | `bool` | `true` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | n/a | `string` | `"default"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Ec2 instance type | `string` | `"t2.small"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `any` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `any` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | n/a | `any` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Enter a cidr block in /16 subnet | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip)  |PUBLIC IP |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) |  VPC ID |

