cmd_sound/core/seq/snd-seq.ko := mipsel-openwrt-linux-musl-ld -r  -m elf32ltsmip -T ./scripts/module-common.lds -s --build-id  -o sound/core/seq/snd-seq.ko sound/core/seq/snd-seq.o sound/core/seq/snd-seq.mod.o ;  true
