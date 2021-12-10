output dns {
  value       = "ssh -i id_rsa ubuntu@${aws_instance.web.public_dns}"
  
}
