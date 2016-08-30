SUMMARY = "Inverse ARP daemon"
DESCRIPTION = "Daemon to respond to Inverse-ARP requests"
HOMEPAGE = "http://github.com/openbmc/inarp"
PR = "r1"

inherit obmc-phosphor-license
inherit obmc-phosphor-systemd

TARGET_CFLAGS   += "-fpic -O2"

SRC_URI += "git://github.com/openbmc/inarp"

SRCREV = "04d1f97f2e6e471d63c7d56dce7bd8472eb8fbfb"

S = "${WORKDIR}/git"

do_install_append() {
        install -d ${D}${sbindir}
        install -m 0755 ${S}/inarp ${D}${sbindir}
}
