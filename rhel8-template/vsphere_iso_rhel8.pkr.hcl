source "vsphere-iso" "rhel8" {
    vcenter_server = var.vsphere_server
    username = var.vsphere_user
    password = var.vsphere_password
    datacenter = var.vsphere_datacenter
    cluster = var.vsphere_cluster
    insecure_connection = var.vsphere_insecure_connection

    vm_name = var.vm_name
    folder = var.vsphere_folder
    guest_os_type = var.vm_guest_os

    ssh_username = var.vm_provisioner_user
    ssh_password = var.vm_provisioner_password

    CPUs = var.vm_cpus
    CPU_hot_plug = var.vm_cpu_hot_plug
    RAM = var.vm_ram
    RAM_hot_plug = var.vm_ram_hot_plug

    disk_controller_type = var.vm_disk_controller_type
    datastore = var.vsphere_datastore
    storage {
        disk_size = var.vm_disk_size 
        disk_eagerly_scrub = var.vm_disk_eagerly_scrub
        disk_thin_provisioned = var.vm_disk_thin_provisioned
    }
 
    iso_paths = [
        "${var.vm_iso_path}",
        "[] /usr/lib/vmware/isoimages/${var.vm_tools_upload_flavor}.iso"
    ]

    cd_files = ["${var.vm_kickstart_file}"] # Requires install of Windows ADK for the oscdimg tool
    cd_label = "OEMDRV" # A drive with this label gets automatically loaded in RHEL 8 Installation

    network_adapters {
        network = var.vsphere_network
        network_card = var.vm_network_card
    }

    boot_command = [
       "<tab><wait>",
       " ip=${var.vm_network_ip}::${var.vm_network_gateway}:${var.vm_network_mask}:${var.vm_name}.${var.vm_domain}:ens192:none inst.text",
       "<enter>"
    ]

    shutdown_command = "sudo su root -c \"/sbin/shutdown -hP now\""
    disable_shutdown = var.vm_disable_shutdown
    remove_cdrom = var.vm_remove_cdrom
    convert_to_template = var.vm_convert_to_template
}

build {
    sources = [
        "source.vsphere-iso.rhel8"
    ]

    provisioner "shell" {
        execute_command = "echo 'provisioner' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
        scripts = [
            "scripts/vmware-tools.sh",
            "scripts/sshd.sh"
        ]
    }
}