#!/bin/sh

# Este script instala os módulos necesários para o baresip
# OBS: executado no linkit


okpg update

opkg install baresip-mod-stdio baresip-mod-g711 baresip-mod-vumeter baresip-mod-alsa baresip-mod-stun baresip-mod-turn baresip-mod-ice baresip-mod-uuid baresip-mod-account baresip-mod-auloop baresip-mod-contact baresip-mod-debug_cmd baresip-mod-menu


