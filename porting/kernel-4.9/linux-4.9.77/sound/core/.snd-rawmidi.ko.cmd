cmd_sound/core/snd-rawmidi.ko := mipsel-openwrt-linux-musl-ld -r  -m elf32ltsmip -T ./scripts/module-common.lds -s --build-id  -o sound/core/snd-rawmidi.ko sound/core/snd-rawmidi.o sound/core/snd-rawmidi.mod.o ;  true
