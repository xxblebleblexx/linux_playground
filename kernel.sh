#configuration
kernel_source=https://android.googlesource.com/kernel/manifest
branch_kernel=common-android15-6.6
defconfig_path=common/arch/arm64/configs/gki_defconfig
#Kernel clone
repo init -u $kernel_source -b $branch_kernel
repo sync -c -j$(nproc) --no-tags
cd common

#Resukisu
curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash

#KSU config
echo "CONFIG_KSU=y" >> $defconfig_path
cd ../

#Run compile
tools/bazel build --config=fast //common:kernel_aarch64_dist
