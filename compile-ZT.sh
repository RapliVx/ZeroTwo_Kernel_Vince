#!/bin/sh
# Compile script for Zero Two kernel
# Copyright (c) RapliVx Aka Rafi Aditya

PHONE="vince"
DEFCONFIG=vince-perf_defconfig
COMPILERDIR="/workspace/ZeroTwo_Kernel_Vince-NO-KSU/clang"
CLANG="Weebx Clang"
export KBUILD_BUILD_USER=Rapli
export KBUILD_BUILD_HOST=PotatoServer


# Header
cyan="\033[96m"
green="\033[92m"
red="\033[91m"
blue="\033[94m"
yellow="\033[93m"

echo -e "$cyan===========================\033[0m"
echo -e "$cyan= START COMPILING KERNEL  =\033[0m"
echo -e "$cyan===========================\033[0m"

echo -e "$blue...KSABAR...\033[0m"

echo -e -ne "$green== (10%)\r"
sleep 0.7
echo -e -ne "$green=====                     (33%)\r"
sleep 0.7
echo -e -ne "$green=============             (66%)\r"
sleep 0.7
echo -e -ne "$green=======================   (100%)\r"
echo -ne "\n"

echo -e -n "$yellow\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

# setup dir
WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image-gz.dtb"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

function clean() {
    echo -e "\n"
    echo -e "$red [!] CLEANING UP \\033[0m"
    echo -e "\n"
    rm -rf out
    make mrproper
}

# Make Defconfig

function build_kernel() {
    export PATH="$COMPILERDIR/bin:$PATH"
    make -j$(nproc --all) O=out ARCH=arm64 ${DEFCONFIG}
    if [ $? -ne 0 ]
then
    echo -e "\n"
    echo -e "$red [!] BUILD FAILED \033[0m"
    echo -e "\n"
else
    echo -e "\n"
    echo -e "$green==================================\033[0m"
    echo -e "$green= [!] START BUILD ${DEFCONFIG}\033[0m"
    echo -e "$green==================================\033[0m"
    echo -e "\n"
fi

# Build Start Here

    make -j$(nproc --all) ARCH=arm64 O=out \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi- 
    if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
    echo -e "$green===========================\033[0m"
    echo -e "$green=  SUCCESS COMPILE KERNEL \033[0m"
    echo -e "$green=  Device    : $PHONE \033[0m"
    echo -e "$green=  Defconfig : $DEFCONFIG \033[0m"
    echo -e "$green=  Toolchain : $CLANG \033[0m"
    echo -e "$green=  Completed in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) \033[0m "
    echo -e "$green=  Have A Brick Day Nihahahah \033[0m"
    echo -e "$green===========================\033[0m"
    else
    echo -e "$red [!] FIX YOUR KERNEL SOURCE BRUH !?\033[0m"
    fi
}

# execute
clean
build_kernel