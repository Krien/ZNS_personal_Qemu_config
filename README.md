# What is this?
This repository contains my personal scripts that I use to launch emulated Zoned Namespaced (ZNS) devices, made public as it may aid someone in their ZNS efforts. I like many others do not have ZNS device(s) at home (in 2022 at least), so I have to resort to emulation. These scripts are used in all ZNS projects that I am working on, because it does not make sense to bundle the emulation scripts with ZNS projects themselves, as the emulation scripts should reside on the host and the code on the emulated machine; repos are not split between devices.  Therefore the emulated devices are defined through these scripts in a separate repository.

The project requires Qemu to be installed and available in the path. It has only been tested on Qemu 6.1.0, but might also work on others.

As the goal of these scripts mainly is to test ZNS, it contains a few different SMALL storage devices, that have at least aided in my own development of ZNS projects. When tested on production, be sure to also test on a REAL device and on a device that is more than 1 GB. To explain the scripts: `./create_images.sh` creates the images (I am not going to share raw images on Github...) and `./start_qemu_zns.sh` starts Qemu to make use of the created images. Feel free to reuse in/for your project, if necessary.

WARNING, running `./create_images.sh` will eat more than 20 GB.