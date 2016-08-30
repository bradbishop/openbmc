SUMMARY = "Phosphor OpenBMC IPMI daemon"
DESCRIPTION = "Phosphor OpenBMC IPMI router and plugin libraries"
HOMEPAGE = "http://github.com/openbmc/phosphor-host-ipmid"
PR = "r1"

RRECOMMENDS_${PN} += "virtual/obmc-phosphor-host-ipmi-hw"

RRECOMMENDS_${PN} += "${VIRTUAL-RUNTIME_obmc-phosphor-ipmi-parsers}"


inherit obmc-phosphor-license
inherit obmc-phosphor-dbus-service

TARGET_CFLAGS   += "-fpic"

DBUS_SERVICE_${PN} = "org.openbmc.HostServices.service"

DEPENDS += "systemd obmc-mapper"
RDEPENDS_${PN}-dev += "obmc-mapper-dev"
RDEPENDS_${PN} += "clear-once"
RDEPENDS_${PN} += "settings"
RDEPENDS_${PN} += "virtual-obmc-netprovider"
RDEPENDS_${PN} += "libmapper"
RDEPENDS_${PN} += "libsystemd"
SRC_URI += "git://github.com/openbmc/phosphor-host-ipmid"

SRCREV = "bc40c178bb0b345ed1edf553b94369330003af34"

S = "${WORKDIR}/git"

do_install() {
        install -m 0755 -d ${D}${libdir}/host-ipmid
        install -m 0755 ${S}/*.so ${D}${libdir}/host-ipmid/

        install -m 0755 -d ${D}${includedir}/host-ipmid
        install -m 0644 ${S}/ipmid-api.h ${D}${includedir}/host-ipmid/

	install -d ${D}${sbindir}
        install -m 0755 ${S}/ipmid ${D}${sbindir}
}
