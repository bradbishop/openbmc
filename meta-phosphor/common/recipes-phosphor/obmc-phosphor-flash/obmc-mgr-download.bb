SUMMARY = "OpenBMC org.openbmc.managers.Download example implementation"
DESCRIPTION = "An example implementation for the org.openbmc.managers.Download DBUS API."
PR = "r1"

PACKAGE_BEFORE_PN += "${PN}-foo"

inherit skeleton-python
inherit obmc-phosphor-dbus-service

FILES_${PN}-foo = "/usr/sbin/*"

MY_SERVICE = "org.openbmc.managers.Download"
OBMC_DBUS_ACTIVATED_SERVICES_${PN} = "${MY_SERVICE}"
OBMC_DBUS_SERVICE_USER_${PN}_${MY_SERVICE} = "obmc-download"

RDEPENDS_${PN} += "\
        python-dbus \
        python-pygobject \
        python-subprocess \
        pyphosphor \
	${PN}-foo \
        "

SKELETON_DIR = "pydownloadmgr"
