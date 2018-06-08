#!/bin/sh

echo "Removing ralink_gdma and i2s modules..."

rmmod "ralink_gdma"
#rmmod "snd_soc_ralink_i2s"

echo "Inserting mtk_ralink_gdma module... "

insmod "mtk_ralink_gdma.ko"

echo "Inserting i2s, i2s-ctl, pcm and machine modules... "

insmod "i2c_wm8960.ko"
insmod "snd-soc-mt76xx-i2s-ctl.ko"
insmod "snd-soc-mt76xx-i2s.ko"
insmod "snd-soc-ralink-i2s.ko"
insmod "snd-soc-mt76xx-pcm.ko"
#insmod "snd-soc-wm8960.ko"
#OUT2VOL = speaker volume (regs 28h e 29h) INVOL = mic volume (regs 00h e 01h)
insmod "snd-soc-wm8960.ko" "OUT2VOL=368" "INVOL=96"
insmod "snd-soc-mt76xx-machine.ko"
#insmod "snd-soc-mt76xx-machine.ko" "ADCLKDIV=54" "DACLKDIV=54" "DCLKDIV=500" "SYSCLKDIV=4" "BCLKDIV=15"

#insmod "snd-soc-mt76xx-machine.ko"

echo "Listing /proc/asound cards... "

ls -l "/proc/asound"

#cp sample8khz.wav /tmp/
#cat /tmp/sample8khz.wav | aplay -M

#mkdir ramfs
#mount ramfs -t ramfs ./ramfs
#mkdir -p /mnt/usb
#mount -t vfat /dev/sda1 /mnt/usb
#cp sample8khz.wav /mnt/usb
#cd /mnt/usb

echo "done"
