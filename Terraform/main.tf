resource "proxmox_vm_qemu" "test_server" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve-1"
    desc = "Ubuntu"
    count = 1
    onboot = true
    
    # The template name to clone this vm from
    clone = "Ubuntu"

    # Activate QEMU agent for this VM
    agent = 0
    cores = 1
    sockets = 1
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 1024
    name = "K8S-VM-0${count.index + 1}"
    scsihw   = "virtio-scsi-pci" 
    bootdisk = "scsi0"

disk {
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "32G"
    type = "scsi"
    storage = "local-lvm"
}
}

