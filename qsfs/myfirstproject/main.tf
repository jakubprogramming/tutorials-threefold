variable "mnemonics" {
  type = string
  sensitive = true
}

variable "network" {
  type = string
}

variable "sshkey" {
  type = string
  sensitive = true
}

provider "grid" {
    mnemonics = var.mnemonics
    network = var.network
}

terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}

resource "grid_network" "net1" {
    nodes = [8]
    ip_range = "10.20.0.0/16"
    name = "mynetwork"
    description = "My internal Grid network"
    add_wg_access = true
}

resource "grid_deployment" "d1" {
  node = 8
  network_name = grid_network.net1.name
#   ip_range = lookup(grid_network.net1.nodes_ip_range, 19, "")
  disks {
    name = "root"
    size = 25
  }
    vms {
    name = "tftest"
    description ="Terraform deployment test"
    flist = "https://hub.grid.tf/tf-official-vms/ubuntu-22.04-lts.flist"
    cpu = 2
    publicip = true
    publicip6 = true
    memory = 2048
    mounts {
        disk_name = "root"
        mount_point = "/data"
    }
    planetary = true
    env_vars = {
      SSH_KEY ="${var.sshkey}"
    }
  }
}


output "wg_config" {
    value = grid_network.net1.access_wg_config
}
output "node1_vm1_ip" {
    value = grid_deployment.d1.vms[0].ip
}
output "public_ip" {
    value = grid_deployment.d1.vms[0].computedip
}
output "public_ip6" {
    value = grid_deployment.d1.vms[0].computedip6
}
output "ygg_ip" {
    value = grid_deployment.d1.vms[0].ygg_ip
}

