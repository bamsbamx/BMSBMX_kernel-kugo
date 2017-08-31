#!/bin/bash

RED=1
GREEN=2
BLUE=4

colorPrint() {
    tput setaf $2
    echo $1
    tput sgr0
}

if [ ! -e utils ]; then
    colorPrint "ERROR: In order to build, you need to execute 'sh BUILDME.sh' in kernel source root instead" $RED
    exit 1
fi

colorPrint "Initializing workspace..." $BLUE

#Device config
device=kugo

#Workspace directories
workdir="$(pwd)"
outputfolder=${workdir}/OUTPUT
outputdir=${outputfolder}/${device}
toolchains=${workdir}/toolchains

#Using Linaro gcc 4.9.4 toolchain 2017.01: http://snapshots.linaro.org/components/toolchain/binaries/4.9-2017.01-rc1/aarch64-linux-gnu/
export ARCH=arm64
export PATH=$workdir/toolchains/linaro-4.9.4-aarch64-linux-gnu/bin/:$PATH
export CROSS_COMPILE=aarch64-linux-gnu-
export KBUILD_DIFFCONFIG=kugo_diffconfig


colorPrint "Cleaning previous builds..." $BLUE

rm -rf $outputdir
mkdir -p $outputdir


colorPrint "Configuring kernel..." $BLUE

make msm-perf_defconfig O=$outputdir


colorPrint "Building kernel..." $BLUE

time make -j8 O=$outputdir 2>&1

if [ ! -f $outputdir/arch/arm64/boot/Image.gz-dtb ]; then
    colorPrint "ERROR: kernel image not found. Kernel build failed" $RED 
    exit 1
fi


if [ ! -e ${workdir}/ramdisk.cpio.gz ]; then
    colorPrint "ERROR: ramdisk image file not found. Compression failed" $RED
    exit 1
fi


colorPrint "Packaging boot image file" $BLUE

cd ${workdir}/utils
sh mkboot.sh
cd ..



