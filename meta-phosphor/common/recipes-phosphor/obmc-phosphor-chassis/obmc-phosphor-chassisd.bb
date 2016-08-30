SUMMARY = "Phosphor OpenBMC Chassis Management"
DESCRIPTION = "Phosphor OpenBMC chassis management reference implementation."
PR = "r1"

inherit allarch
inherit obmc-phosphor-chassis-mgmt
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-license

RDEPENDS_${PN} += "python-dbus python-pygobject"

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
