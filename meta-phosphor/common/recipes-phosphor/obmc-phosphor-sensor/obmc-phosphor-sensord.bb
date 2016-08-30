SUMMARY = "Phosphor OpenBMC Sensor Management"
DESCRIPTION = "Phosphor OpenBMC sensor management reference implementation."
PR = "r1"

inherit obmc-phosphor-sensor-mgmt
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
