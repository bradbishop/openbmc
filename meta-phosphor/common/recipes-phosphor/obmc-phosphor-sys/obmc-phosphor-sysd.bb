SUMMARY = "Phosphor OpenBMC System Management"
DESCRIPTION = "Phosphor OpenBMC system management reference implementation."
PR = "r1"

inherit allarch
inherit obmc-phosphor-license
inherit obmc-phosphor-dbus-service

RPROVIDES_${PN} += "virtual-obmc-system-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RDEPENDS_${PN} += "python-dbus python-pygobject"

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
