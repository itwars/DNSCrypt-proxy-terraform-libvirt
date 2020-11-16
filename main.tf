# provider

terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# load data
data "template_file" "user_data" {
  template = file(var.user_data_source)
  vars = {
  	hostname = "srv-${random_id.randomId.hex}"
  }
}

data "template_file" "network_config" {
  template = file(var.network_config_source)
}

# create pool
resource "libvirt_pool" "alpine" {
  name = var.pool_name
  type = "dir"
  path = var.pool_dir
}

resource "libvirt_volume" "os_image" {
  source = var.image_source   
  name = "img-${random_id.randomId.hex}.qcow2"
  pool = libvirt_pool.alpine.name
}


# create image
resource "libvirt_volume" "image-qcow2"{
  name = "disk-${random_id.randomId.hex}"
  base_volume_id = libvirt_volume.os_image.id
  pool = libvirt_pool.alpine.name
  format = "qcow2"
  size   = 1 * 1024 * 1024 * 1024
}

# cloudinit
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit-${random_id.randomId.hex}.iso"
  pool = libvirt_pool.alpine.name
  user_data = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

resource "random_id" "randomId" {
    keepers = {
  store = libvirt_pool.alpine.id
    }
    byte_length = 4
}

# Define KVM domain to create
resource "libvirt_domain" "virt-domain" {
  description = "dnscrypt-proxy"
  name = "srv-${random_id.randomId.hex}"
  memory = var.domain_memory
  vcpu   = var.domain_cpu
  autostart = true
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  qemu_agent = true
  network_interface {
     bridge = "br0"
     wait_for_lease = true
  }

  provisioner "local-exec" {
    command = <<EOT
        echo "[dnscrypt]\n${self.network_interface.0.addresses.0} ansible_user=devops" > ./hosts.ini 
        sleep 30
	     ansible-playbook site.yml -i hosts.ini 
    EOT
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

    disk {
    volume_id = libvirt_volume.image-qcow2.id
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
