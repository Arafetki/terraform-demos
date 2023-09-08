output "ec2_public_ip" {
  value = aws_instance.demo_public.public_ip
}

output "demo_private_ip" {
  value = aws_instance.demo_private.private_ip
}