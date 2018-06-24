SUMMARY = "Basic initramfs init script for booting Apollo"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI = "file://init-apollo.sh"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/init-apollo.sh ${D}/init
}

inherit allarch

FILES_${PN} += " /init "
RDEPENDS_${PN} += "busybox"
