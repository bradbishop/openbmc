SUMMARY = "Phosphor OpenBMC Fan Management."
DESCRIPTION = "Phosphor OpenBMC fan management reference implementation."
PR = "r1"

inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-license

RPROVIDES_${PN} += "virtual-obmc-fan-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"

DEPENDS += "systemd"
RDEPENDS_${PN} += "libsystemd"

S = "${WORKDIR}"
SRC_URI += "file://Makefile \
           file://obmc-phosphor-fand.c \
           "

do_install_append() {
        # install the binary
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN} ${D}${sbindir}
}
