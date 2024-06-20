output "vpc_id" {
  value = aws_vpc.sky.id
}

output "pub_sub1" {
  value = aws_subnet.public_subnet1.id
}

output "public_subent2" {
  value = aws_subnet.public_subnet2.id
}

output "private_subent1" {
  value = aws_subnet.private_subnet1.id
}

# output "public_subent1" {
#   value = aws_subnet.jump_host_sub.id
# }