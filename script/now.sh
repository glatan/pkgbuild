#!/usr/bin/env bash

yum update -y
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash
yum install -y git-lfs

git clone https://gitlab.com/glatan/pkgbuild.git
cd pkgbuild || exit
git lfs pull
cp -rf release ../release
