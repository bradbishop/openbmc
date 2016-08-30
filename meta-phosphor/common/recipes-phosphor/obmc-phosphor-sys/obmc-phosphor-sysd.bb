SUMMARY = "Phosphor OpenBMC System Management"
DESCRIPTION = "Phosphor OpenBMC system management reference implementation."
PR = "r1"

inherit obmc-phosphor-system-mgmt
inherit obmc-phosphor-py-daemon
inherit obmc-phosphor-dbus-service

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"
