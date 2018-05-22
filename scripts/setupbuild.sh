#!/bin/sh

# kversion="kernel-4.9"
kversion="kernel-4.14"
cd ../lede/$kversion

./config_linkit.sh

# git ch 298a51ae07b68a2fdc42977bce74c237612e9c1c
# git stash
# git reset --hard 298a51ae07b68a2fdc42977bce74c237612e9c1c
# git stash pop

cd ../../../

git submodule add https://git.openwrt.org/project/luci.git lede/$kversion/feeds/luci ;
git submodule add https://git.openwrt.org/feed/packages.git lede/$kversion/feeds/packages;
git submodule add https://git.openwrt.org/feed/routing.git lede/$kversion/feeds/routing;
git submodule add https://git.openwrt.org/feed/telephony.git lede/$kversion/feeds/telephony;
git submodule add https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git lede/$kversion/feeds/linkit;