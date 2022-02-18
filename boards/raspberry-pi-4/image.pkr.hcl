source "arm" "deluge" {
  file_urls             = ["http://cdimage.ubuntu.com/releases/20.04.2/release/ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz"]
  file_checksum_url     = "http://cdimage.ubuntu.com/releases/20.04.2/release/SHA256SUMS"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]

  image_build_method = "reuse"
  image_path         = "ubuntu-20.04.img"
  image_size         = "3.1G"
  image_type         = "dos"
  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "2048"
    filesystem   = "fat"
    size         = "256M"
    mountpoint   = "/boot/firmware"
  }
  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "526336"
    filesystem   = "ext4"
    size         = "2.8G"
    mountpoint   = "/"
  }
  image_chroot_env = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]

  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}

build {
  sources = ["source.arm.deluge"]

  # Init for network
  provisioner "shell" {
    inline = [
      "mv /etc/resolv.conf /etc/resolv.conf.bk",
      "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
    ]
  }

  # Setup Pi User
  provisioner "shell" {
    script = "scripts/ubuntu/create-user.sh"
    environment_vars = ["USER=${local.pi_user}"]
  }

  # Local configs. Populate these manually!
  provisioner "file" {
    source = "conf"
    destination = "/conf"
  }


  # Configure SSH Host
  provisioner "shell" {
    inline = [
      "mv /conf/authorized_keys /home/${local.pi_user}/.ssh/authorized_keys"
    ]
  }

  # Server folder with docker-compose files
  provisioner "file" {
    source = "server"
    destination = "/server"
  }

  # Install Docker
  provisioner "shell" {
    script = "scripts/ubuntu/install-docker.sh"
  }
}

locals {
  pi_user = "pi"
}