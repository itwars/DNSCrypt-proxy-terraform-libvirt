
output "ip" {
  value = libvirt_domain.virt-domain.network_interface[0].addresses[0]
}
output "http" {
  value = "http://${libvirt_domain.virt-domain.network_interface[0].addresses[0]}"
}
