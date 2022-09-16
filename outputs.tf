output "splunk-login-address" {
  value       = "http://${aws_spot_instance_request.splunk.public_ip}:8000"
  description = "The public IP of the splunk"
}

output "splunk-login-user-pass" {
  value       = "user: admin, pass=SPLUNK-${aws_spot_instance_request.splunk.spot_instance_id}"
  description = "user and password to login into splunk"
}

