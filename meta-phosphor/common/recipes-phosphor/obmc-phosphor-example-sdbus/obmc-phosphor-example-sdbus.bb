SUMMARY = "Phosphor OpenBMC BSP Example Application"
DESCRIPTION = "Phosphor OpenBMC QEMU BSP example implementation."
PR = "r1"

DEPENDS += "systemd"
RDEPENDS_${PN} += "libsystemd"
DBUS_SERVICE_${PN} += "org.openbmc.examples.SDBusService.service"

S = "${WORKDIR}"
SRC_URI += "file://Makefile \
           file://obmc-phosphor-example-sdbus.c \
           "
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-c-daemon
