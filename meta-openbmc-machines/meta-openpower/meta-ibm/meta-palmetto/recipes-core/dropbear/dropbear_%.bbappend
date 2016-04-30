FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://dropbear_rsa_host_key"

FILES_${PN} += "/etc/dropbear/dropbear_rsa_host_key"

do_install_append() {
        install -m 600 ${WORKDIR}/dropbear_rsa_host_key ${D}/etc/dropbear/dropbear_rsa_host_key
}

