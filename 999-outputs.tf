output "instance" {
  value = openstack_compute_instance_v2.instance
  sensitive = true
}

output "instance_count" {
  value = var.instance_count
}

output "ip" {
  value = openstack_networking_floatingip_v2.ip
}
