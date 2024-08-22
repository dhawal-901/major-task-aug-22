output "public_ips" {
  description = "Public Instance IPs"
  value       = [for instance in aws_instance.my_public_instance : instance.public_ip]
}
output "private_ips" {
  description = "Private Instance IPs"
  value       = [for instance in aws_instance.my_private_instance : instance.private_ip]
}
