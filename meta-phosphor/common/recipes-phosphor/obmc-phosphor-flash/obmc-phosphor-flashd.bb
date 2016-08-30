SUMMARY = "Phosphor OpenBMC Flash Management"
DESCRIPTION = "Phosphor OpenBMC flash management reference implementation."
PR = "r1"

inherit obmc-phosphor-dbus-service
inherit allarch
inherit obmc-phosphor-license

RPROVIDES_${PN} += "virtual-obmc-flash-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"

RDEPENDS_${PN} += "python-dbus python-pygobject"

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
