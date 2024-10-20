output "instance_public_ip" {
  description = "Publiczny adres IP instancji EC2"
  value       = aws_instance.elk_server.public_ip
}

output "instance_id" {
  description = "ID instancji EC2"
  value       = aws_instance.elk_server.id
}