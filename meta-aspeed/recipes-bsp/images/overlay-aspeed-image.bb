DESCRIPTION = "An empty filesystem for creating overlays."

PACKAGE_INSTALL = ""

# Do not pollute the overlay image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "overlay-aspeed-image"
IMAGE_LINGUAS = ""

LICENSE = "MIT"

IMAGE_FSTYPES = "${OVERLAY_FSTYPE}"
OVERLAY_FSTYPE ?= "jffs2"

overlay_aspeed_clear_rootfs() {
	rm -rf ${IMAGE_ROOTFS}/*
}

IMAGE_PREPROCESS_COMMAND = "overlay_aspeed_clear_rootfs;"

# Skip prelink since the image is empty
IMAGE_PREPROCESS_COMMAND_remove = "prelink_setup;"
IMAGE_PREPROCESS_COMMAND_remove = "prelink_image;"

inherit image
