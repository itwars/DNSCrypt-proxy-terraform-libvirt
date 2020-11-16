# the variables

variable "pool_name"{
  description = "name of to create pool"
  type = string
  default = "alpine-pool-1"
}

variable "pool_dir"{
  description = "dir of the new pool"
  type = string
  default = "/srv/terraform_libvirt_provider_images_1/"
}

variable "domain_name"{
  description = "name of the image including the format"
  type = string
  default = "alpine-picalcserver-1"
}

variable "image_name"{
  description = "name of the image including the format"
  type = string
  default = "alpine-3.12.0-amd64-libvirt.qcow2"
}

variable "common_name"{
  description = "name of cloud init disk"
  type = string
  default = "alpine-s1"
}

variable "image_source"{
  description = "path to image source"
  type = string
  default = "./alpine-3.12.0-amd64-libvirt.qcow2"
}

variable "user_data_source"{
  description = "path to use data"
  type = string
  default = "./user_data.cfg"
}

variable "network_config_source"{
  description = ""
  default = "./network_config.cfg"
}

variable "domain_memory"{
  description = "name of the volume"
  type = string
  default = 512
}

variable "domain_cpu"{
  description = "name of the volume"
  type = string
  default = 1
}

variable "network_name"{
  description = "name of virtual network"
  type = string
  default = "default"
}

#variable "macaddress"{
#  description = "machine address"
#  type = string
#}


