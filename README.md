# What is this?
This repository contains my personal scripts that I use to launch emulated Zoned Namespaced (ZNS) devices, made public as it may aid someone in their ZNS efforts. I like many others do not have ZNS device(s) at home (in 2022 at least), so I have to resort to emulation. These scripts are used in all ZNS projects that I am working on, because it does not make sense to bundle the emulation scripts with ZNS projects themselves, as the emulation scripts should reside on the host and the code on the emulated machine; repos are not split between devices.  Therefore the emulated devices are defined through these scripts in a separate repository.  Feel free to reuse in/for your project, if necessary.

The project requires Qemu to be installed and available in the path. It has only been tested on Qemu 6.1.0 on Ubuntu 20.04 LTS specifically, but might also work on others.

## How to use
This projects comes with two scripts: `./create_images.sh` and `./start_qemu_zns.sh`.
To explain the scripts: `./create_images.sh` creates the storage device images (I am not going to share raw images on Github...) and `./start_qemu_zns.sh` starts Qemu to make use of the created images. Note that these scripts only creates the storage devices, you do still need your own qcow image, such as Ubuntu. This image is probably different from mine, so alter `image` in  `./start_qemu_zns.sh` to your own.

WARNING, running `./create_images.sh` will eat more than 20 GB.

## Workloads
As the goal of these scripts mainly is to test ZNS, it contains a few different SMALL storage devices and different configurations, that have at least aided in my own development of ZNS projects. By default it has a small device to test basic functionality, a bigger one that crosses the 32-bit boundary (8GB) and an image with non-standard configs. Variables can be altered directly in `start_qemu_zns.sh`. When tested on production, be sure to also test on a REAL device and on a device that is more than 1 GB. 