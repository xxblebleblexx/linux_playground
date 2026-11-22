#configuration
kernel_source=https://android.googlesource.com/kernel/manifest
branch_kernel=common-android15-6.6-2026-10
defconfig_path=arch/arm64/configs/gki_defconfig
#Kernel clone
repo init -u $kernel_source -b $branch_kernel --depth=1
repo sync -c -j4 --no-tags --optimized-fetch --prune
cd common

#rename
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/e31863df324b2a8659b922e738a7afbb064fe5e2.diff
patch -p1 < e31863df324b2a8659b922e738a7afbb064fe5e2.diff

#disable check_defconfig
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/b22b72dafed521020549b720bc0d2594843d837e.diff
patch -p1 < b22b72dafed521020549b720bc0d2594843d837e.diff

#Disable ABI protect
rm -rf android/abi_gki_protected_exports_aarch64
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/66dd340f3170f008d302a1e1a12b0915edf1dd2e.diff
patch -p1 < 66dd340f3170f008d302a1e1a12b0915edf1dd2e.diff

#Fix dirty build
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/0b6cada5e347f8bba33a59441d2ca9e297cf2628.diff
patch -p1 < 0b6cada5e347f8bba33a59441d2ca9e297cf2628.diff

#Nomount driver
echo "CONFIG_NOMOUNT=y" >> $defconfig_path
curl https://raw.githubusercontent.com/maxsteeel/nomount/refs/heads/dev/kernel/setup.sh | bash -

#BakaSU
echo "CONFIG_KSU=y" >> $defconfig_path
curl -LSs "https://raw.githubusercontent.com/Baka-SU/BakaSU/main/kernel/setup.sh" | bash

#end
cd ../

#Run compile
export KBUILD_CFLAGS="-mllvm -enable-ml-inliner=release -mllvm -enable-ml-regalloc=release"
tools/bazel run --config=fast //common:kernel_aarch64_config -- savedefconfig
tools/bazel run --config=fast //common:kernel_aarch64_dist -- --destdir=out/dist
