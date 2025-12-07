// tests/plan_test.tftest.hcl

run "plan_test" {
  // Use plan rather than apply
  command = plan

  plan_options {
    // don't refresh remote state / external changes
    refresh = false
  }


  variables {
    proxmox_vm_metadata = {
    agent       = true
    tags        = ["dns"]
    description = "dns server"
    name        = "test"
    vm_id = 700
    }
    
    proxmox_vm_boot_image = {
    url = "https://repo.almalinux.org/almalinux/10/cloud/x86_64_v2/images/AlmaLinux-10-GenericCloud-latest.x86_64_v2.qcow2"
    }
    proxmox_vm_cpu = {
    cores = 2
    }
    proxmox_vm_disks = [{
    datastore_id = "local-zfs"
    file_format  = "raw"
    interface    = "virtio0"
    size         = 10
    }]
    proxmox_vm_memory = {
    dedicated = 2048
    }
    proxmox_vm_network = {
    dns = {
        domain  = ".Home"
        servers = ["1.1.1.1", "1.0.0.1"]
    }
    
    ip_config = {
        ipv4 = {
        address = "192.168.0.101/24",
        gateway = "192.168.0.1"
        },
        ipv6 = {
        address = "dhcp"
        gateway = "hello"
        }
    }
    }
    proxmox_vm_user_account = {
    username = "test"
    }

  }

  

  assert {
    // Another example: check that an output value equals something
    // If you have an output defined in outputs.tf
    condition     = output.proxmox_vm.vm_id == 700
    error_message = "Output `vm_id` was incorrect: ${nonsensitive(output.proxmox_vm.vm_id)}"
  }

#   assert {
    # // Another example: check that an output value equals something
    # // If you have an output defined in outputs.tf
    # condition     = output.ip_config.ipv4[0] == "192.168.0.101"
    # error_message = "Output `ipv4 address` was incorrect: ${output.ip_config.ipv4[0]}"
#   }

    assert {
        condition = output.node_name == "pve"
        error_message = "Output `node_name` was incorrect: ${output.node_name}"
    }

    # check rest of plan lines up
    # assert {
        # condition = proxmox_virtual_environment_download_file.proxmox_vm_boot_image["1"].id != null
        # error_message = "boot image file was null"
    # }

}


run "apply_test" {
  // Use plan rather than apply
  command = apply

  plan_options {
    // don't refresh remote state / external changes
    refresh = false
  }


  variables {
    proxmox_vm_metadata = {
    agent       = true
    tags        = ["dns"]
    description = "dns server"
    name        = "test"
    vm_id = 700
    }
    
    proxmox_vm_boot_image = {
    url = "https://repo.almalinux.org/almalinux/10/cloud/x86_64_v2/images/AlmaLinux-10-GenericCloud-latest.x86_64_v2.qcow2"
    }
    proxmox_vm_cpu = {
    cores = 2
    }
    proxmox_vm_disks = []
    proxmox_vm_memory = {
    dedicated = 2048
    }
    proxmox_vm_network = {
    dns = {
        domain  = ".Home"
        servers = ["1.1.1.1", "1.0.0.1"]
    }
    
    ip_config = {
        ipv4 = {
        address = "192.168.0.101/24",
        gateway = "192.168.0.1"
        },
        ipv6 = {
        address = "dhcp"
        gateway = "hello"
        }
    }
    }
    proxmox_vm_user_account = {
    username = "test"
    }

  }

  

  assert {
    // Another example: check that an output value equals something
    // If you have an output defined in outputs.tf
    condition     = output.proxmox_vm.vm_id == 700
    error_message = "Output `vm_id` was incorrect: ${nonsensitive(output.proxmox_vm.vm_id)}"
  }

  assert {
    // Another example: check that an output value equals something
    // If you have an output defined in outputs.tf
    condition     = output.ip_config.ipv4[0] == "192.168.0.101"
    error_message = "Output `ipv4 address` was incorrect: ${output.ip_config.ipv4[0]}"
  }

    assert {
        condition = output.node_name == "pve"
        error_message = "Output `node_name` was incorrect: ${output.node_name}"
    }

    # check rest of plan lines up
    assert {
        condition = proxmox_virtual_environment_download_file.proxmox_vm_boot_image["1"].id != null
        error_message = "boot image file was null"
    }

}


provider "proxmox" {

  # because self-signed TLS certificate is in use
  insecure = true
  # uncomment (unless on Windows...)
  # tmp_dir  = "/var/tmp"

  ssh {
    agent = true

  }
}