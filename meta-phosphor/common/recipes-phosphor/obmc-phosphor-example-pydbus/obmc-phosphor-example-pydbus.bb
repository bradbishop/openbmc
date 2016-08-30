SUMMARY = "Phosphor OpenBMC BSP Example Application"
DESCRIPTION = "Phosphor OpenBMC QEMU BSP example implementation."
PR = "r1"

inherit obmc-phosphor-dbus-service
inherit allarch
inherit obmc-phosphor-license


DBUS_SERVICE_${PN} = "org.openbmc.examples.PythonService.service"

RDEPENDS_${PN} += "python-dbus python-pygobject"

client = "pyclient-sample"
SRC_URI += "file://${client}.py"
SRC_URI += "file://${PN}.py"
S = "${WORKDIR}"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${S}/${client}.py ${D}${bindir}/${client}
        install -d ${D}${sbindir}
        install -m 0755 ${S}/${PN}.py ${D}${sbindir}/${PN}
}
