workdir="$(dirname "$(pwd)")"
ramdiskoutput=${workdir}/ramdisks/kugo/ramdisk

if [ ! -e kernel.elf ]; then
    echo "elf file not found. Expected at $(pwd)/kernel.elf"
    exit 1
fi


echo "Extracting ramdisk from image file..."

./bootimg unpackelf -i kernel.elf -r ramdisk.cpio.gz


echo "Decompressing ramdisk..."

gunzip -c ramdisk.cpio.gz | ./bootimg unpackinitfs -d $ramdiskoutput

rm -f ramdisk.cpio.gz

echo "DONE"
echo "Ramdisk contents can be found at $ramdiskoutput"
