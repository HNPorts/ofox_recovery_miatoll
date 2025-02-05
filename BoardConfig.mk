#
# Copyright 2024 The Android Open Source Project
#
#  Copyright (C) 2021-2024 The OrangeFox Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# 64-bit
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_IS_64_BIT := true

# Bootloader
PRODUCT_PLATFORM := atoll
TARGET_BOOTLOADER_BOARD_NAME := atoll
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := atoll
TARGET_BOARD_PLATFORM_GPU := qcom-adreno618
QCOM_BOARD_PLATFORMS += atoll

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 \
	androidboot.hardware=qcom \
	androidboot.console=ttyMSM0 \
	androidboot.memcg=1 \
	lpm_levels.sleep_disabled=1 \
	video=vfb:640x400,bpp=32,memsize=3072000 \
	msm_rtb.filter=0x237 \
	service_locator.enable=1 \
	androidboot.usbcontroller=a600000.dwc3 \
	swiotlb=2048 \
	cgroup.memory=nokmem,nosocket \
	androidboot.selinux=permissive \
	androidboot.init_fatal_reboot_target=recovery

BOARD_KERNEL_IMAGE_NAME := Image

BOARD_KERNEL_PAGESIZE := 4096
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE          := 0x00000000
BOARD_KERNEL_TAGS_OFFSET   := 0x00000100
BOARD_KERNEL_OFFSET        := 0x00008000
BOARD_KERNEL_SECOND_OFFSET := 0x00f00000
BOARD_RAMDISK_OFFSET       := 0x01000000
BOARD_DTB_OFFSET           := 0x01f00000
TARGET_KERNEL_ARCH := arm64

BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_KERNEL_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# --- Prebuilt kernel
# whether to do an inline build of the kernel sources
ifeq ($(FOX_BUILD_FULL_KERNEL_SOURCES),1)
    TARGET_KERNEL_SOURCE := kernel/xiaomi/miatoll
    TARGET_KERNEL_CONFIG := vendor/curtana-fox_defconfig
    TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-gnu-
    TARGET_KERNEL_ADDITIONAL_FLAGS := DTC_EXT=$(shell pwd)/prebuilts/misc/$(HOST_OS)-x86/dtc/dtc
    TARGET_KERNEL_CLANG_COMPILE := true
    KERNEL_SUPPORTS_LLVM_TOOLS := true
    TARGET_KERNEL_CLANG_VERSION := 13.0.0
    TARGET_KERNEL_CLANG_PATH := $(shell pwd)/prebuilts/clang/host/linux-x86/clang-$(TARGET_KERNEL_CLANG_VERSION)
else
    BOARD_INCLUDE_RECOVERY_DTBO := true
    BOARD_INCLUDE_DTB_IN_BOOTIMG := true
    ifeq ($(FOX_VARIANT),FBEv2)
   	KERNEL_DIRECTORY := $(DEVICE_PATH)/prebuilt/fbev2
    else
    	KERNEL_DIRECTORY := $(DEVICE_PATH)/prebuilt
    endif
    BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_DIRECTORY)/dtbo.img
    TARGET_PREBUILT_KERNEL := $(KERNEL_DIRECTORY)/Image.gz-dtb
    BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_DIRECTORY)/dtbs
endif # inline kernel build

# Avb
BOARD_AVB_ENABLE := true
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 134217728
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728
BOARD_DTBOIMG_PARTITION_SIZE := 8388608

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9126805504
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := product vendor system system_ext

# System as root
BOARD_ROOT_EXTRA_FOLDERS := bluetooth dsp firmware persist
BOARD_SUPPRESS_SECURE_ERASE := true

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true

# TWRP specific build flags
TW_THEME := portrait_hdpi
RECOVERY_SDCARD_ON_DATA := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_EXCLUDE_TWRPAPP := true
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := true

# building
LC_ALL := C
ALLOW_MISSING_DEPENDENCIES := true

# AVB stuff
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

#
TARGET_COPY_OUT_PRODUCT := product
TW_INCLUDE_RESETPROP := true

# cure for "ELF binaries" problems
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# deal with "error: overriding commands for target" problems
BUILD_BROKEN_DUP_RULES := true

# frame rate
TW_FRAMERATE := 60

# FBEv1 or FBEv2 ?
ifeq ($(FOX_VARIANT),FBEv2)
   TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/FBEv2/recovery-fbev2.fstab
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv2/recovery-fbev2-wrap0.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery-fbev2-wrap0.fstab
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv2/twrp-fbev2.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv2/wrappedkey-fix-fbev2.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wrappedkey-fix.sh
   TW_MAX_BRIGHTNESS := 4095
   TW_DEFAULT_BRIGHTNESS := 1638
else
   TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/FBEv1/recovery-fbev1.fstab
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv1/recovery-fbev1.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery-fbev1.fstab
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv1/twrp-fbev1.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags
   PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/FBEv1/wrappedkey-fix-fbev1.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wrappedkey-fix.sh
   TW_MAX_BRIGHTNESS := 2047
   TW_DEFAULT_BRIGHTNESS := 1200
endif
#
# debug for backups
# TW_LIBTAR_DEBUG := true
#

# device information for "fastboot update <zip-file>"
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt
#
