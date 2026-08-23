#configuration
kernel_source=https://github.com/aosp-mirror/kernel_common.git
branch_kernel=deprecated/android15-6.6-2024-08
defconfig_path=arch/arm64/configs/gki_defconfig
defconfig=gki_defconfig

#Toolchain export
export PATH=$(pwd)/clang/bin:$PATH
export KBUILD_CFLAGS="-mllvm -enable-ml-inliner=release -mllvm -enable-ml-regalloc=release"

#Kernel clone
git clone -b $branch_kernel --depth=1 $kernel_source kernel
cd kernel

#Resukisu
curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash

#KSU config
echo "CONFIG_KSU=y" >> $defconfig_path
#Run compile
make O=out ARCH=arm64 $defconfig; printf "n\n2\n\n\n\nY\n" | make -j$(nproc --all) KCFLAGS="-Wno-error=-Wmacro-redefined" CC=clang O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf STRIP=llvm-strip
