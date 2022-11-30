terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Defining VM Volume
resource "libvirt_volume" "ubuntu" {
  name = "ubuntu"
  pool = "default" # List storage pools using virsh pool-list
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  #source = "./jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "ubuntu" {
  name   = "ubuntu"
  memory = "512"
  vcpu   = 2

  network_interface {
    network_name = "default" # List networks with virsh net-list
  }

  disk {
    volume_id = "${libvirt_volume.ubuntu.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

# Defining VM Volume
resource "libvirt_volume" "fedora" {
  name = "fedora"
  pool = "default" # List storage pools using virsh pool-list
  source = "https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/36/Cloud/x86_64/images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2"
  #source = "./Fedora-Cloud-Base-36-1.5.x86_64.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "fedora" {
  name   = "fedora"
  memory = "512"
  vcpu   = 2

  network_interface {
    network_name = "default" # List networks with virsh net-list
  }

  disk {
    volume_id = "${libvirt_volume.fedora.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
