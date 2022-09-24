output "instance_public_ip" {
  description = "public ip for EC2 instance"
  value       = [for instance in aws_instance.ec2demo : instance.public_dns]
}

output "instance_public_dns_loop" {
  description = "public dns for EC2 instance"
  value       = [for instance in aws_instance.ec2demo : instance.public_dns]
}

output "instance_public_dns_map" {
  description = "public dns for EC2 instance"
  value       = { for instance in aws_instance.ec2demo : instance.id => instance.public_dns }
}

output "instance_public_dns_map_advance" {
  description = "public dns for EC2 instance"
  value       = { for i, instance in aws_instance.ec2demo : i => instance.public_dns }
}
