#!/bin/sh

echo "reset git local changes"

git fetch --all
git reset --hard origin/master

