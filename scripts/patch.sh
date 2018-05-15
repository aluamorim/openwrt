#!/bin/bash
# Execute este script a partir do diretório scripts/
# Ele deve alterar o código baixado em "kpath", substituindo
# os arquivos do porting de áudio.

#kernel version
#kversion="4.14.37"
kversion="4.9.77"
#code path
cpath="../lede/kernel-4.9"

# user can specitfy code path and version
if [ "$#" -eq 2 ]; then
	cpath=$1
	kversion=$2
fi 

#kernel path inside code path
kpath="$cpath/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion"

#porting path
ppath="../porting/kernel-$kversion"

rm -rf "$kpath/sound"
rm -rf "$kpath/include/sound"

rm -rf "$cpath/package/"
tar -xvf "$ppath/package.tar.xz" -C "$cpath/"
# cp -R "$ppath/base-files/" "$cpath/package/"
cp -R "$ppath/linux-$kversion/sound/" "$kpath/"
cp -R "$ppath/linux-$kversion/include/sound/" "$kpath/include/"
cp "$ppath/linux-$kversion/include/linux/interrupt.h" "$kpath/include/linux/"
cp "$ppath/linux-$kversion/include/trace/events/asoc.h" "$kpath/include/trace/events/"

if [ "$kversion" == "4.14.37" ]; then
cp "$ppath/linux-$kversion/include/linux/wait.h" "$kpath/include/linux/"
cp "$ppath/package/kernel/linux/modules/sound.mk" "$cpath/package/kernel/linux/modules/"
cp -R "$ppath/feeds/packages/libs/alsa-lib/" "$cpath/feeds/packages/libs/"
cp -R "$ppath/feeds/packages/sound/alsa-utils/" "$cpath/feeds/packages/sound/"	
fi

