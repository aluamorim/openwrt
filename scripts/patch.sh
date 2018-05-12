#!/bin/bash
# Execute este script a partir do diretório scripts/
# Ele deve alterar o código baixado em "kpath", substituindo
# os arquivos do porting de áudio.

#kversion="4.14.37"
kversion="4.9.77"
spath="../openwrt"
kpath="$spath/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion"
ppath="../porting/kernel-$kversion"


if [ "$#" -eq 2 ]; then
	spath=$1
	kversion=$2
fi 

rm -rf "$kpath/sound"
rm -rf "$kpath/include/sound"


cp -R "$ppath/linux-$kversion/sound/" "$kpath/"
cp -R "$ppath/linux-$kversion/include/sound/" "$kpath/include/"
cp "$ppath/linux-$kversion/include/linux/interrupt.h" "$kpath/include/linux/"
cp "$ppath/linux-$kversion/include/trace/events/asoc.h" "$kpath/include/trace/events/"
#cp "$ppath/linux-$kversion/include/linux/wait.h" "$kpath/include/linux/"
#cp "$ppath/package/kernel/linux/modules/sound.mk" "$spath/package/kernel/linux/modules/"
#cp -R "$ppath/feeds/packages/libs/alsa-lib/" "$spath/feeds/packages/libs/"
#cp -R "$ppath/feeds/packages/sound/alsa-utils/" "$spath/feeds/packages/sound/"

