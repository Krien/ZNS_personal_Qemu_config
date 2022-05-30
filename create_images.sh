#!/bin/env bash
set -e

qemuimg=qemu-img

if [ ! -f nvmessd-32M.img ]; then
    $qemuimg create -f raw nvmessd-32M.img 32M
fi
if [ ! -f nvmessd-4G.img ]; then
    $qemuimg create -f raw nvmessd-4G.img 4G
fi
if [ ! -f znsssd-128M.img ]; then
    $qemuimg create -f raw znsssd-128M.img 128M
fi
if [ ! -f znsssd2-128M.img ]; then
    $qemuimg create -f raw znsssd2-128M.img 128M
fi
if [ ! -f znsssd3-8G.img ]; then
    $qemuimg create -f raw znsssd3-8G.img 8G
fi
if [ ! -f znsssd4-8G.img ]; then
    $qemuimg create -f raw znsssd4-8G.img 8G
fi
if [ ! -f znsssd5-1G.img ]; then
    $qemuimg create -f raw znsssd5-1G.img 1G
fi
if [ ! -f znsssd6-1G.img ]; then
    $qemuimg create -f raw znsssd6-1G.img 1G
fi
