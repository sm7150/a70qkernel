# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers
# firemax13 @ xda-developers
# firemax13 @ github

## AnyKernel setup
# begin properties
properties() { '
kernel.string=FireKernel by Ice Destroyer @ xda-developers
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=10-11
'; } # end properties

block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
. tools/ak3-core.sh;
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
dump_boot;
write_boot;
