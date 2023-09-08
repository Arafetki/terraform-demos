output "ec2_public_ip" {
  value = aws_instance.demo_public.public_ip
}