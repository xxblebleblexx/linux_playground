#configuration
kernel_source=https://github.com/xxblebleblexx/android_kernel_xiaomi_gale.git
branch_kernel=refactor
defconfig_path=arch/arm64/configs/moonbeam_defconfig
defconfig=moonbeam_defconfig

#Toolchain export
export PATH=$(pwd)/clang/bin:$PATH
export KBUILD_CFLAGS="-mllvm -enable-ml-inliner=release -mllvm -enable-ml-regalloc=release"

#Kernel clone
git clone -b $branch_kernel --depth=1 $kernel_source kernel
cd kernel

#Run compile
make O=out ARCH=arm64 $defconfig; printf "n\n2\n\n\n\nY\n" | make -j$(nproc --all) CC=clang O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf STRIP=llvm-strip
