#!/bin/bash
# Execute este script a partir do diretório scripts/
# Ele deve alterar o código baixado em "kpath", substituindo
# os arquivos do porting de áudio.

#kernel version
kversion="4.14.37"

#code path
cpath="../lede/kernel-4.14"

#kernel path inside code path
kpath="$cpath/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-$kversion"

#porting path
ppath="../porting/kernel-$kversion"

# rm -rf "$kpath/sound"
# rm -rf "$kpath/include/sound"
rm -rf "$cpath/package"

# cp -R "$ppath/base-files/" "$cpath/package/"
#cp -R "$ppath/linux-$kversion/sound/" "$kpath/"
#cp -R "$ppath/linux-$kversion/include/sound/" "$kpath/include/"
#cp -R "$ppath/linux-$kversion/include/soc/" "$kpath/include/"
#cp "$ppath/linux-$kversion/include/linux/interrupt.h" "$kpath/include/linux/"
#cp "$ppath/linux-$kversion/include/trace/events/asoc.h" "$kpath/include/trace/events/"
#cp "$ppath/linux-$kversion/include/linux/wait.h" "$kpath/include/linux/"

cp -R "$ppath/linux-$kversion/sound/soc/mtk" "$kpath/sound/soc/"

cp "$ppath/linux-$kversion/sound/soc/Kconfig" "$kpath/sound/soc/"
cp "$ppath/linux-$kversion/sound/soc/Makefile" "$kpath/sound/soc/"

cp "$ppath/linux-$kversion/sound/Kconfig" "$kpath/sound/"
cp "$ppath/linux-$kversion/sound/Makefile" "$kpath/sound/"

cp -R "$ppath/package/" "$cpath/"


