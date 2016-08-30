SUMMARY = "Phosphor OpenBMC Flash Management"
DESCRIPTION = "Phosphor OpenBMC flash management reference implementation."
PR = "r1"

inherit obmc-phosphor-flash-mgmt
inherit obmc-phosphor-py-daemon
inherit obmc-phosphor-dbus-service

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"
