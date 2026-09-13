#!/bin/sh

#setup mandatory packages
sudo pacman -Sy --noconfirm git repo patch llvm lld base-devel ncurses openssl bc flex bison rsync kmod cpio python ccache tar gzip zstd wget;wait
#repo dummy email
git config --global user.email "fufufafa@gmail.com"
git config --global user.name "fufufafa"
