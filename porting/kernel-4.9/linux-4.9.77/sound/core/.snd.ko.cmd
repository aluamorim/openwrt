cmd_sound/core/snd.ko := mipsel-openwrt-linux-musl-ld -r  -m elf32ltsmip -T ./scripts/module-common.lds -s --build-id  -o sound/core/snd.ko sound/core/snd.o sound/core/snd.mod.o ;  true
