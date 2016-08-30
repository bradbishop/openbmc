SUMMARY = "Phosphor OpenBMC Chassis Management"
DESCRIPTION = "Phosphor OpenBMC chassis management reference implementation."
PR = "r1"

inherit obmc-phosphor-chassis-mgmt
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-py-daemon

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"
