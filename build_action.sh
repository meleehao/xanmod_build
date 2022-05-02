#!/usr/bin/env bash

#VERSION=$(grep 'Kernel Configuration' < config | awk '{print $3}')
VERSION=5.17.5-xanmod1
# add deb-src to sources.list
sed -i "/deb-src/s/# //g" /etc/apt/sources.list

# install dep
sudo apt update
sudo apt install -y wget
sudo apt build-dep -y linux

# change dir to workplace
cd "${GITHUB_WORKSPACE}" || exit

# download kernel source
#wget http://www.kernel.org/pub/linux/kernel/v5.x/linux-"$VERSION".tar.xz
wget https://hub.fastgit.xyz/xanmod/linux/archive/refs/tags/5.17.5-xanmod1.tar.gz
#tar -xf linux-"$VERSION".tar.xz
tar -xzvf  "$VERSION".tar.gz
#cd linux-"$VERSION" || exit
cd "$VERSION"
# copy config file
cp ../config .config

# disable DEBUG_INFO to speedup build
#scripts/config --disable DEBUG_INFO

# apply patches
# shellcheck source=src/util.sh
#source ../patch.d/*.sh

# build deb packages
CPU_CORES=$(($(grep -c processor < /proc/cpuinfo)*2))
make  -j"$CPU_CORES"

# move deb packages to artifact dir
cd ..
mkdir "build_kernel_package"
mv ./arch/x86_64/boot/bzImage  build_kernel_pacakge/linux.img
