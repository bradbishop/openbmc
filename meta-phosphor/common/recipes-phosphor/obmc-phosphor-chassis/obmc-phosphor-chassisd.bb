SUMMARY = "Phosphor OpenBMC Chassis Management"
DESCRIPTION = "Phosphor OpenBMC chassis management reference implementation."
PR = "r1"

inherit allarch
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-license

PROVIDES += "virtual/obmc-chassis-mgmt"
RPROVIDES_${PN} += "virtual-obmc-chassis-mgmt"
RDEPENDS_${PN} += "python-dbus python-pygobject"

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
