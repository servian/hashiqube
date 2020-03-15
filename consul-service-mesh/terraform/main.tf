data "external" "myipaddress" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

output "OnPrem_hashiqube0-service-consul" {
  value = data.external.myipaddress.result.ip
}
