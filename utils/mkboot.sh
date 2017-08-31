# Use this script if you want to skip the kernel build and make the boot.img file (i.e. in case only ramdisk is modified)

RED=1
GREEN=2
BLUE=4

colorPrint() {
    tput setaf $2
    echo $1
    tput sgr0
}

#Device config
device=kugo

#Workspace directories
workdir="$(dirname "$(pwd)")"
outputfolder=${workdir}/OUTPUT
outputdir=${outputfolder}/${device}
ramdisk=${workdir}/ramdisks/${device}/ramdisk


if [ ! -f $outputdir/arch/arm64/boot/Image.gz-dtb ]; then
    colorPrint "ERROR: kernel image not found. Must build kernel first" $RED 
    exit 1
fi


if [ -e $outputdir/boot.img ]; then
    colorPrint "Cleaning previous builds..." $BLUE
    rm -f $outputdir/boot.img
    colorPrint "Packaging boot image file" $BLUE
fi


${workdir}/utils/mkbootimg --kernel $outputdir/arch/arm64/boot/Image.gz-dtb --ramdisk ${workdir}/ramdisk.cpio.gz --cmdline "androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 zram.backend=z3fold earlyprintk buildvariant=user" --base 0x20000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01E00000 -o ${outputdir}/boot.img

if [ ! -f $outputdir/boot.img ]; then
    colorPrint "ERROR: boot image file not found. boot packaging failed" $RED
    exit 1
fi


colorPrint "DONE" $GREEN
colorPrint "boot image file can be found at ${outputdir}/boot.img" $GREEN
