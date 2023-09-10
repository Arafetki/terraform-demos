output "ec2_public_ip" {
  description = " The public ip address of demo_public instance"
  value       = aws_instance.demo_public.public_ip
}

output "ec2_private_ip" {
  description = "The private ip address of demo_private instance"
  value       = aws_instance.demo_private.private_ip
}

output "ami_id" {
  description = "The ami id used in creating the demo instances"
  value       = data.aws_ami.latest_ubuntu.id
}