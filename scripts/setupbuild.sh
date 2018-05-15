#!/bin/sh

cd ../lede/kernel-4.9

./config_linkit.sh

cd feeds/linkit
git reset --hard 78f124d5f9d027b7dadc293b06296631f4bbf871
git stash
git reset --hard 78f124d5f9d027b7dadc293b06296631f4bbf871
git stash pop

cd ../../../

git submodule add https://git.openwrt.org/project/luci.git lede/kernel-4.9/feeds/luci ;
git submodule add https://git.openwrt.org/feed/packages.git lede/kernel-4.9/feeds/packages;
git submodule add https://git.openwrt.org/feed/routing.git lede/kernel-4.9/feeds/routing;
git submodule add https://git.openwrt.org/feed/telephony.git lede/kernel-4.9/feeds/telephony;
git submodule add https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git lede/kernel-4.9/feeds/linkit;