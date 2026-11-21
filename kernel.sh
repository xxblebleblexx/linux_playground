#configuration
kernel_source=https://android.googlesource.com/kernel/manifest
branch_kernel=common-android15-6.6
defconfig_path=arch/arm64/configs/gki_defconfig
#Kernel clone
repo init -u $kernel_source -b $branch_kernel
repo sync -c -j$(nproc) --no-tags --no-clone-bundle
cd common

#rename
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/e31863df324b2a8659b922e738a7afbb064fe5e2.diff
patch -p1 < e31863df324b2a8659b922e738a7afbb064fe5e2.diff

#disable check_defconfig
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/b22b72dafed521020549b720bc0d2594843d837e.diff
patch -p1 < b22b72dafed521020549b720bc0d2594843d837e.diff

#BakaSU
curl -LSs "https://raw.githubusercontent.com/Baka-SU/BakaSU/main/kernel/setup.sh" | bash

#KSU config
echo "CONFIG_KSU=y" >> $defconfig_path
cd ../

#Run compile
export KBUILD_CFLAGS="-mllvm -enable-ml-inliner=release -mllvm -enable-ml-regalloc=release"
tools/bazel run --config=fast //common:kernel_aarch64_dist -- --destdir=out/dist
