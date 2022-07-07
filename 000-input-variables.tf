variable "key_pair_name" {
  type = string
  description = <<EOF
The name of the ssh key referenced in openstack
EOF
  default = null
}

variable "image_id" {
  type = string
  description = <<EOF
The image's id referenced in openstack
EOF
  default = null
}

variable "name" {
  type = string
  description = <<EOF
Instance's name
EOF
}

variable "flavor_name" {
  type = string
  description = <<EOF
Instance's flavor name referenced in openstack
EOF
}

variable "public_ip_network" {
  type = string
  description = <<EOF
The name of the network who give floating IPs
EOF
  default = null
}

variable "is_public" {
  type = bool
  description = <<EOF
Boolean who allow you to to make public or not your instance
EOF
  default = true
}

variable "ports" {
  type = list(object({
    name = string
    network_id = string
    subnet_id = string
    admin_state_up = optional(bool)
    security_group_ids = optional(list(string))
    no_security_groups = optional(bool)
    port_security_enabled = optional(bool)
    ip_address = optional(string)
  }))
  description = <<EOF
The ports list, at least 1 port is required
EOF
  default = []
}

variable "block_device_volume_size" {
  type = number
  description = <<EOF
The volume size of block device
EOF
  default = 20
}

variable "block_device_delete_on_termination" {
  type = bool
  description = <<EOF
Delete block device when instance is shut down
EOF
  default = true
}

variable "server_groups" {
  type = list(string)
  description = <<EOF
List of server group id
EOF
  default = []
}

variable "block_device" {
  description = "Additional block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "network_name" {
  type        = list(map(string))
  default     = []
}

variable "instance_count" {
  type        = number
  default     = 1
}

variable "tags" {
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = " (Optional) Metadata key/value pairs to make available from within the instance"
  type        = map(string)
  default     = null
}
