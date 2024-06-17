output "ec2_ssh_key" {
  value = aws_key_pair.deployer.key_name
}