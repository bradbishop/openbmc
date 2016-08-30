SUMMARY = "Phosphor OpenBMC Sensor Management"
DESCRIPTION = "Phosphor OpenBMC sensor management reference implementation."
PR = "r1"

inherit obmc-phosphor-sensor-mgmt
inherit obmc-phosphor-py-daemon
inherit obmc-phosphor-dbus-service

S = "${WORKDIR}"
SRC_URI += "file://${PN}.py"
