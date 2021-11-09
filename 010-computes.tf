#
# Create instance
#
resource "openstack_compute_instance_v2" "instance" {
  count       = var.instance_count
  name        = var.instance_count == 1 ? var.name : "${var.name}-${count.index + 1}"
  flavor_name = var.flavor_name

  dynamic "block_device" {
    for_each = var.block_device
    content {
      uuid                  = lookup(block_device.value, "uuid", null)
      source_type           = lookup(block_device.value, "source_type", null)
      volume_size           = lookup(block_device.value, "volume_size", 10)
      guest_format          = lookup(block_device.value, "guest_format", null)
      boot_index            = lookup(block_device.value, "boot_index", 0)
      destination_type      = lookup(block_device.value, "destination_type", null)
      delete_on_termination = lookup(block_device.value, "delete_on_termination", false)
      volume_type           = lookup(block_device.value, "volume_type", null)
      device_type           = lookup(block_device.value, "device_type", null)
      disk_bus              = lookup(block_device.value, "disk_bus", null)
    }
  }

  key_pair = var.key_pair_name

  dynamic "scheduler_hints" {
    for_each = var.server_groups
    content {
      group = scheduler_hints.value
    }
  }

  dynamic "network" {
    for_each = openstack_networking_port_v2.port

    content {
      port = network.value["id"]
    }
  }

  dynamic "network" {
    for_each = var.network_name 

    content {
      name = lookup(network.value, "name", null)
    }

  }
  
  metadata = var.metadata

  tags = var.tags

  user_data = var.user_data
}

# Create network port

resource "openstack_networking_port_v2" "port" {
  count = length(var.ports)

  name = var.ports[count.index].name
  network_id = var.ports[count.index].network_id
  admin_state_up = var.ports[count.index].admin_state_up == null ? true : var.ports[count.index].admin_state_up
  security_group_ids = var.ports[count.index].security_group_ids == null ? [] : var.ports[count.index].security_group_ids
  fixed_ip {
    subnet_id = var.ports[count.index].subnet_id
    ip_address = var.ports[count.index].ip_address == null ? null : var.ports[count.index].ip_address
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "ip" {
  count = var.is_public ? 1 : 0

  pool = var.public_ip_network
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "ipa" {
  count = var.is_public ? 1: 0

  floating_ip = openstack_networking_floatingip_v2.ip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}
