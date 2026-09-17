#!/bin/sh

#setup mandatory packages
sudo pacman -Sy --noconfirm git patch llvm lld base-devel ncurses openssl bc flex bison rsync kmod cpio python ccache tar gzip zstd wget;wait
#Toolchain compiler
wget https://github.com/Neutron-Toolchains/clang-build-catalogue/releases/download/06092026/neutron-clang-06092026.tar.zst;wait
mkdir -p clang
mv neutron-clang-06092026.tar.zst clang/
cd clang
tar --zstd -xf neutron-clang-06092026.tar.zst

#MLGO
wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/mlgo-models.tar.gz
tar -zxvf mlgo-models.tar.gz
cd ..

#test clang
export PATH=$(pwd)/clang/bin:$PATH
clang --version
