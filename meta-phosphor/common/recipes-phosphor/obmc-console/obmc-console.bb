SUMMARY = "OpenBMC console daemon"
DESCRIPTION = "Daemon to handle UART console connections"
HOMEPAGE = "http://github.com/openbmc/obmc-console"
PR = "r1"

inherit obmc-phosphor-license
inherit obmc-phosphor-systemd
inherit autotools

TARGET_CFLAGS   += "-fpic -O2"

SRC_URI += "git://github.com/openbmc/obmc-console"
SRC_URI += "file://${PN}.conf"

SRCREV = "6221ce9483f9431061223f635a4dbd82e44dc75b"

SYSTEMD_SERVICE_${PN} = " \
        ${PN}.service \
        ${PN}-ssh.socket \
        ${PN}-ssh@.service \
        "

do_install_append() {
        install -m 0755 -d ${D}${sysconfdir}
        install -m 0644 ${WORKDIR}/${PN}.conf ${D}${sysconfdir}/${PN}.conf
}

S = "${WORKDIR}/git"
