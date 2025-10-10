output "vpc_id" {
  description = "Output for VPC ID"
  value = module.vpc.vpc_id
}

output "ec2_ip" {
  description = "Output for EC2 Public IP"
  value = module.ec2_instance.public_ip
}

output "my_sg_id" {
  description = "Output for my Security Group"
  value = aws_security_group.my_sg.id
}