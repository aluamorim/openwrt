#!/bin/sh

git submodule add https://git.openwrt.org/project/luci.git lede/kernel-4.9/feeds/luci ;
git submodule add https://git.openwrt.org/feed/packages.git lede/kernel-4.9/feeds/packages;
git submodule add https://git.openwrt.org/feed/routing.git lede/kernel-4.9/feeds/routing;
git submodule add https://git.openwrt.org/feed/telephony.git lede/kernel-4.9/feeds/telephony;
git submodule add https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git lede/kernel-4.9/feeds/linkit;