#!/bin/sh
qemu=qemu-system-x86_64 # << set to your Qemu installation!

image="ubuntu-20.04.qcow" # Set to your image!!!

# config
port_local=7777 # < Set to your desired port
port_image=22   # < Set to the exposed port on the image
memory=12G      # RAM
smp=4           # SMP

# used for debugging non-zns 
smallnvme="nvmessd-32M.img"
nvme_blocksize=512
# used for hybrid approaches (e.g. F2FS)
bignvme="nvmessd-4G.img"
# small IO (should be similar sized disks for benchmarking)
smallzns="znsssd-128M.img"
smallzns2="znsssd2-128M.img"
smallzns_logical_blocksize=4096
smallzns_physical_blocksize=4096
smallzns_zonesize=2M
smallzns_zonecap=1M
smallzns_max_open=16
smallzns_max_active=32
smallzns_mdts=8
smallzns_zasl=5
smallzns_max_ioqpairs=64
# bigger IO (should be similar sized disks for benchmarking)
biggerzns="znsssd3-8G.img"
biggerzns2="znsssd4-8G.img"
biggerzns_logical_blocksize=512
biggerzns_physical_blocksize=512
biggerzns_zonesize=2M
biggerzns_zonecap=1M
biggerzns_max_open=16
biggerzns_max_active=32
biggerzns_mdts=8
biggerzns_zasl=5
biggerzns_max_ioqpairs=64
# different ZNS configurations (different zonesize, lbasize etc...)
altzns="znsssd5-1G.img"
altzns2="znsssd6-1G.img"
altzns_logical_blocksize=512
altzns_physical_blocksize=512
altzns_zonesize=4M
altzns_zonecap=2M
altzns_max_open=16
altzns_max_active=32
altzns_mdts=9
altzns_zasl=0
altzns_max_ioqpairs=32
# taken from https://zonedstorage.io/docs/tools/qemu, better not alter...
zns_uuid=5e40ec5f-eeb6-4317-bc5e-c919796a5f79

# I thought we were going to write Bash?
# This was mainly done to reduce column width as Qemu's opts are "," separated, so "\" will not work.
# If we want we can make this shorter with double evaluation, but not sure if this destroys readability.
nvme_opts="physical_block_size=$nvme_blocksize,logical_block_size=$nvme_blocksize"

zns_opts="uuid=${zns_uuid},zoned=true"

small_ctrl_opts="mdts=${smallzns_mdts},zoned.zasl=${smallzns_zasl},max_ioqpairs=${smallzns_max_ioqpairs}"
small_opts="logical_block_size=${smallzns_logical_blocksize},physical_block_size=${smallzns_physical_blocksize}"
small_opts="${small_opts},zoned.zone_size=${smallzns_zonesize},zoned.zone_capacity=${smallzns_zonecap}"
small_opts="${small_opts},zoned.max_open=${smallzns_max_open},zoned.max_active=${smallzns_max_active}"

bigger_ctrl_opts="mdts=${biggerzns_mdts},zoned.zasl=${biggerzns_zasl},max_ioqpairs=${biggerzns_max_ioqpairs}"
bigger_opts="logical_block_size=${biggerzns_logical_blocksize},physical_block_size=${biggerzns_physical_blocksize}"
bigger_opts="${bigger_opts},zoned.zone_size=${biggerzns_zonesize},zoned.zone_capacity=${biggerzns_zonecap}"
bigger_opts="${bigger_opts},zoned.max_open=${biggerzns_max_open},zoned.max_active=${biggerzns_max_active}"

alt_ctrl_opts="mdts=${altzns_mdts},zoned.zasl=${altzns_zasl},max_ioqpairs=${altzns_max_ioqpairs}"
alt_opts="logical_block_size=${altzns_logical_blocksize},physical_block_size=${altzns_physical_blocksize}"
alt_opts="${alt_opts},zoned.zone_size=${altzns_zonesize},zoned.zone_capacity=${altzns_zonecap}"
alt_opts="${alt_opts},zoned.max_open=${altzns_max_open},zoned.max_active=${altzns_max_active}"

# launch setup
$qemu -name qemuzns                                             \
--enable-kvm                                                    \
-vnc :0                                                         \
-m "$memory" -cpu host -smp "$smp"                              \
-hda "$image"                                                   \
-net user,hostfwd=tcp::"$port_local"-:"$port_image" -net nic    \
\
-drive file="$smallnvme",id=nvme-device,format=raw,if=none    \
-device "nvme,drive=nvme-device,serial=nvme-dev,${nvme_opts}" \
\
-drive file="$bignvme",id=nvme-device2,format=raw,if=none       \
-device "nvme,drive=nvme-device2,serial=nvme-dev2,${nvme_opts}" \
\
-drive file="$smallzns",id=zns-device1,format=raw,if=none     \
-drive file="$smallzns2",id=zns-device2,format=raw,if=none    \
-drive file="$biggerzns",id=zns-device3,format=raw,if=none    \
-drive file="$biggerzns2",id=zns-device4,format=raw,if=none   \
-drive file="$altzns",id=zns-device5,format=raw,if=none       \
-drive file="$altzns2",id=zns-device6,format=raw,if=none      \
\
-device "nvme,serial=zns-dev1,id=nvme2,${small_ctrl_opts}"  \
-device "nvme,serial=zns-dev2,id=nvme3,${small_ctrl_opts}"  \
-device "nvme,serial=zns-dev3,id=nvme4,${bigger_ctrl_opts}" \
-device "nvme,serial=zns-dev4,id=nvme5,${bigger_ctrl_opts}" \
-device "nvme,serial=zns-dev5,id=nvme6,${alt_ctrl_opts}"    \
-device "nvme,serial=zns-dev6,id=nvme7,${alt_ctrl_opts}"    \
\
-device "nvme-ns,drive=zns-device1,bus=nvme2,nsid=1,${zns_opts},${small_opts}"  \
-device "nvme-ns,drive=zns-device2,bus=nvme3,nsid=1,${zns_opts},${small_opts}"  \
-device "nvme-ns,drive=zns-device3,bus=nvme4,nsid=1,${zns_opts},${bigger_opts}" \
-device "nvme-ns,drive=zns-device4,bus=nvme5,nsid=1,${zns_opts},${bigger_opts}" \
-device "nvme-ns,drive=zns-device5,bus=nvme6,nsid=1,${zns_opts},${alt_opts}"    \
-device "nvme-ns,drive=zns-device6,bus=nvme7,nsid=1,${zns_opts},${alt_opts}"    \
