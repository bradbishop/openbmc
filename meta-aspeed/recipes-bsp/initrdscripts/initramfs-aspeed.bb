# This is mostly a copy/paste of the debug init script from meta-initramfs.
SUMMARY = "Extremely basic Aspeed initramfs init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${ASPEEDBASE}/COPYING.MIT;md5=838c366f69b72c5df05c96dff79b35f2"
SRC_URI = "file://init-aspeed.sh"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/init-aspeed.sh ${D}/init
}

inherit allarch

FILES_${PN} += " /init "
RDEPENDS_${PN} += "busybox"
