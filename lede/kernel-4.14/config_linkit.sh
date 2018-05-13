#!/bin/sh

cp feeds.conf.default feeds.conf
echo src-git linkit https://github.com/MediaTek-Labs/linkit-smart-7688-feed.git >> feeds.conf
./scripts/feeds update
./scripts/feeds install -a
