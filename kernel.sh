#configuration
kernel_source=https://android.googlesource.com/kernel/manifest
branch_kernel=common-android15-6.6
defconfig_path=common/arch/arm64/configs/gki_defconfig
#Kernel clone
repo init -u $kernel_source -b $branch_kernel
repo sync -c -j$(nproc) --no-tags
cd common

#disable check_defconfig
wget https://github.com/xxblebleblexx/android_kernel_xiaomi_gale_6.6/commit/f4814d6dfd114d08b834117129bec247d89767c1.diff
patch -p1 < f4814d6dfd114d08b834117129bec247d89767c1.diff
#Resukisu
curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash

#KSU config
echo "CONFIG_KSU=y" >> $defconfig_path
cd ../

#Run compile
tools/bazel run --config=fast //common:kernel_aarch64_dist -- --destdir=out/dist
