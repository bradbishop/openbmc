SUMMARY = "Phosphor OpenBMC BSP Example Application"
DESCRIPTION = "Phosphor OpenBMC QEMU BSP example implementation."
PR = "r1"

inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-py-daemon

DBUS_SERVICE_${PN} = "org.openbmc.examples.PythonService.service"

client = "pyclient-sample"
SRC_URI += "file://${client}.py"
SRC_URI += "file://${PN}.py"
S = "${WORKDIR}"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${S}/${client}.py ${D}${bindir}/${client}
}
