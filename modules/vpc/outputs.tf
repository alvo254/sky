output "vpc_id" {
  value = aws_vpc.sky.id
}

output "pub_sub1" {
  value = aws_subnet.public_subnet1.id
}

output "private_subent1" {
  value = aws_subnet.private_subnet1.id
}