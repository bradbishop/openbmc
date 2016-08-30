SUMMARY = "Phosphor systemd-networkd translator"
DESCRIPTION = "networkd-wrapper implements the OpenBMC network \
DBus API using a systemd-networkd backend."
HOMEPAGE = "http://github.com/openbmc/phosphor-networkd"
PR = "r1"

inherit obmc-phosphor-license
inherit obmc-phosphor-dbus-service

PROVIDES += "virtual/obmc-netprovider"
RPROVIDES_${PN} += "virtual-obmc-netprovider"
DEPENDS += "systemd"
DBUS_SERVICE_${PN} += "org.openbmc.NetworkManager.service"
SYSTEMD_SERVICE_${PN} += "network-update-dns.service"

RDEPENDS_${PN} += "libsystemd python-dbus python-pygobject python-ipy"

SRC_URI += "git://github.com/openbmc/phosphor-networkd"

SRCREV = "75757c08579200677391f5319aee68cafcae0bf1"

S = "${WORKDIR}/git"

do_install() {
        install -d ${D}/${sbindir}
        install ${S}/netman.py ${D}/${sbindir}
        install ${S}/netman_watch_dns ${D}/${sbindir}
}

