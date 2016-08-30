SUMMARY = "Phosphor OpenBMC Policy Management"
DESCRIPTION = "Phosphor OpenBMC policy management reference implementation."
PR = "r1"

inherit obmc-phosphor-policy-mgmt
inherit allarch
inherit obmc-phosphor-license
inherit obmc-phosphor-dbus-service

RDEPENDS_${PN} += "python-dbus python-pygobject"

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
