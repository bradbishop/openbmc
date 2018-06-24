inherit image_types

UBOOT_SUFFIX ?= "bin"
INITRAMFS_IMAGE ?= "initramfs-apollo-image"
INITRAMFS_IMAGE_NAME ?= "${INITRAMFS_IMAGE}-${MACHINE}"
KERNEL_FIT_LINK_NAME ?= "${MACHINE}"

APOLLO_MTD_KERNEL_IMAGE ?= "fitImage-${INITRAMFS_IMAGE_NAME}-${KERNEL_FIT_LINK_NAME}"
APOLLO_MTD_ROOTFS_TYPE ?= "squashfs-xz"
OVERLAY_TYPE ?= "jffs2"
APOLLO_MTD_OVERLAY_IMAGE ?= "overlay-apollo-image"
APOLLO_MTD_UBOOT_OFFSET ?= "0"
APOLLO_MTD_KERNEL_OFFSET ?= "512"
APOLLO_MTD_ROOTFS_OFFSET ?= "4864"
APOLLO_MTD_OVERLAY_OFFSET ?= "28672"
APOLLO_MTD_SIZE ?= "32786"

MTDIMG = "${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.apollo-mtdimg"

IMAGE_TYPEDEP_apollo-mtdimg = "${APOLLO_MTD_ROOTFS_TYPE}"

do_image_apollo_mtdimg[depends] = " \
        virtual/kernel:do_deploy \
        virtual/bootloader:do_deploy \
        ${APOLLO_MTD_OVERLAY_IMAGE}:do_image_complete \
        "

IMAGE_CMD_apollo-mtdimg () {
	dd if=/dev/zero bs=1k count=${APOLLO_MTD_SIZE} \
		| tr '\000' '\377' > ${MTDIMG}

	dd bs=1k conv=notrunc seek=${APOLLO_MTD_UBOOT_OFFSET} \
		if=${DEPLOY_DIR_IMAGE}/u-boot.${UBOOT_SUFFIX} \
		of=${MTDIMG}

	dd bs=1k conv=notrunc seek=${APOLLO_MTD_KERNEL_OFFSET} \
		if=${DEPLOY_DIR_IMAGE}/${APOLLO_MTD_KERNEL_IMAGE} \
		of=${MTDIMG}

	dd bs=1k conv=notrunc seek=${APOLLO_MTD_ROOTFS_OFFSET} \
		if=${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${APOLLO_MTD_ROOTFS_TYPE} \
		of=${MTDIMG}

	dd bs=1k conv=notrunc seek=${APOLLO_MTD_OVERLAY_OFFSET} \
		if=${DEPLOY_DIR_IMAGE}/${APOLLO_MTD_OVERLAY_IMAGE}-${MACHINE}.${OVERLAY_TYPE} \
		of=${MTDIMG}
}
