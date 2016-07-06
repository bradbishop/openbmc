SUMMARY = "Phosphor OpenBMC DBUS Permissions"
DESCRIPTION = "Phosphor OpenBMC DBUS Permissions."
HOMEPAGE = "http://github.com/openbmc/"
PR = "r1"

inherit allarch
inherit dbus-dir
inherit obmc-phosphor-license

SRC_URI += "file://org.openbmc.conf"

do_install_append() {
        install -d ${D}${dbus_system_confdir}
        install -m 644 ${WORKDIR}/org.openbmc.conf ${D}${dbus_system_confdir}
}
