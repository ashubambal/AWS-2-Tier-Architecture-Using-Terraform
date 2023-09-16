output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "client_sg" {
  value = aws_security_group.client_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}