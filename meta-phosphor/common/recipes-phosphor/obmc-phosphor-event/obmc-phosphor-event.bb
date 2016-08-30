SUMMARY = "Phosphor OpenBMC Event Management"
DESCRIPTION = "Phosphor OpenBMC event management reference implementation."
HOMEPAGE = "https://github.com/openbmc/phosphor-event"
PR = "r1"


inherit obmc-phosphor-license
inherit obmc-phosphor-event-mgmt
inherit obmc-phosphor-dbus-service

TARGET_CPPFLAGS += "-std=c++11 -fpic"

SRC_URI += "git://github.com/openbmc/phosphor-event"

SRCREV = "4dad23916e69d55d692eca7389d67eb023c5ca66"

RDEPENDS_${PN} += "libsystemd"
DEPENDS += "systemd"

DBUS_SERVICE_${PN} = "org.openbmc.records.events.service"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "obmc/eventd/eventd.conf"

S = "${WORKDIR}/git"

do_install() {
        install -d ${D}/var/lib/obmc/events/
        install -m 0755 -d ${D}${sbindir}
        install -m 0755 ${S}/event_messaged ${D}${sbindir}
}
