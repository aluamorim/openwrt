cmd_sound/soundcore.ko := mipsel-openwrt-linux-musl-ld -r  -m elf32ltsmip -T ./scripts/module-common.lds -s --build-id  -o sound/soundcore.ko sound/soundcore.o sound/soundcore.mod.o ;  true
