APOLLO_IMAGE_INSTALL = " \
    i2c-tools \
    dropbear \
    libstdc++ \
    ${@d.getVar('PREFERRED_PROVIDER_u-boot-fw-utils', True) or 'u-boot-fw-utils'} \
    "
APOLLO_USERS_PARAMS = " \
    usermod -p '\$1\$UGMqyqdG\$0KM.GMP4bijuC8PxK1Ce6/' root; \
    "

# image tweaks for apollo team builds
CORE_IMAGE_EXTRA_INSTALL_append = " ${APOLLO_IMAGE_INSTALL}"

INHERIT += "extrausers"
EXTRA_USERS_PARAMS_pn-core-image-minimal = "${APOLLO_USERS_PARAMS}"

IMAGE_CLASSES_append = " image_types_apollo"
IMAGE_FSTYPES ?= "apollo-mtdimg"
INITRAMFS_IMAGE = "initramfs-apollo-image"
