# Utilities and shortcuts for applications providing a D-Bus service.
# Variables:
#  OBMC_DBUS_SERVICE_PACKAGES ?= "${PN}"
#    The list of packages to which files should be added.
#
#  OBMC_DBUS_SERVICES_${PN} += "org.openbmc.Foo"
#    A list of dbus service names.  The class will look for a systemd
#      service file with the same name with .service appended and add
#      it to the package.  Additionally the BusName and Type keys in
#      the systemd unit file will be added, if they aren't already present.
#
#    The class will look for a dbus configuration file with the same
#      name with .conf appended.  If one is found, it is added to the
#      package and used verbatim.  If it is not found, a default one
#      (with very open permissions) is generated and used.
#
#  OBMC_DBUS_SERVICE_USER_${PN}_org.openbmc.Foo = 'root'
#    The user a service should be configured to run as.
#
#  OBMC_DBUS_ACTIVATED_SERVICES_${PN} += "org.openbmc.Foo"
#    A list of services that should have dbus activation configured.
#      Services that appear here need not be in OBMC_DBUS_SERVICES.
#      If used, the search pattern for the systemd unit file is
#      changed to be dbus-%s.service.  The class will look for a
#      dbus activation file with the same name with .service appended.
#      If one is found, it added to the package and used verbatim.
#      If it is not found, a default one is generated and used.

inherit dbus-dir
inherit obmc-phosphor-utils

_INSTALL_DBUS_CONFIGS=""
_INSTALL_DBUS_ACTIVATIONS=""


python do_unit_defaults_and_properties() {
    def make_default_dbus_config(d, service, user):
        path = d.getVar('WORKDIR', True)
        with open('%s/%s.conf' % (path, service), 'w+') as fd:
            fd.write('<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"\n')
            fd.write('        "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">\n')
            fd.write('<busconfig>\n')
            fd.write('        <policy user="%s">\n' % user)
            fd.write('                <allow own="%s"/>\n' % service)
            fd.write('                <allow send_destination="%s"/>\n' % service)
            fd.write('        </policy>\n')
            fd.write('</busconfig>\n')
            fd.close()


    def make_default_dbus_activation(d, service, user):
        path = d.getVar('WORKDIR', True)
        with open('%s/%s.service' % (path, service), 'w+') as fd:
            fd.write('[D-BUS Service]\n')
            fd.write('Name=%s\n' % service)
            fd.write('Exec=/bin/false\n')
            fd.write('User=%s\n' % user)
            fd.write('SystemdService=dbus-%s\n' % service)
            fd.close()


    def add_dbus_properties(d, pkg, unit, parser):
        if not parser.has_section('Service'):
            parser.add_section('Service')
        if not parser.has_option('Service', 'Type'):
            parser.set('Service', 'Type', 'dbus')
        if not parser.has_option('Service', 'BusName'):
            service = unit.replace('.service', '')
            parser.set('Service', 'BusName', service)


    service_users = (d.getVar('_DEFAULT_DBUS_CONFIGS', True) or '').split()
    for service_user in service_users:
        make_default_dbus_config(d, *service_user.split(':'))

    service_users = (d.getVar('_DEFAULT_DBUS_ACTIVATIONS', True) or '').split()
    for service_user in service_users:
        make_default_dbus_activation(d, *service_user.split(':'))

    foreach_list(
        d,
        '_UPDATE_DBUS_UNITS',
        update_unit_file,
        [ add_dbus_properties ])
}


python() {
    searchpaths = d.getVar('FILESPATH', True)


    def add_dbus_config(d, service, pkg):
        path = bb.utils.which(searchpaths, '%s.conf' % service)
        if not os.path.isfile(path):
            user = d.getVar(
                'OBMC_DBUS_SERVICE_USER_%s_%s' % (pkg, service), True)
            d.appendVar('_DEFAULT_DBUS_CONFIGS', '%s:%s' % (
                service, user))
        else:
            d.appendVar('SRC_URI', ' file://%s.conf' % service)
        d.appendVar('FILES_%s' % pkg, ' %s%s.conf' \
            % (d.getVar('dbus_system_confdir', True), service))
        d.appendVar('_INSTALL_DBUS_CONFIGS', ' %s.conf' % service)


    def add_dbus_activation(d, service, pkg):
        path = bb.utils.which(searchpaths, '%s.service' % service)
        if not os.path.isfile(path):
            d.appendVar('_DEFAULT_DBUS_ACTIVATIONS', '%s:%s' % (
                service, pkg))
        else:
            d.appendVar('SRC_URI', ' file://%s.service' % service)
        d.appendVar('FILES_%s' % pkg, ' %s%s.service' \
            % (d.getVar('dbus_system_servicesdir', True), service))
        d.appendVar('_INSTALL_DBUS_ACTIVATIONS', ' %s.service' % service)


    def add_sd_unit(d, prefix, service, pkg):
        if prefix:
            d.setVar(
                'OBMC_SD_INSTALL_TARGET_%s_%s%s.service' % (
                    pkg, prefix, service),
                '%%skip%%')
        d.appendVar(
            'OBMC_SD_UNITS_%s' % pkg, ' %s%s.service' % (
                prefix, service))
        d.appendVar('_UPDATE_DBUS_UNITS', ' %s%s.service:%s' % (
                prefix, service, pkg))


    def add_sd_user(d, prefix, service, pkg):
        user = d.getVar(
            'OBMC_DBUS_SERVICE_USER_%s_%s' % (pkg, service), True)
        if user:
            d.appendVar('OBMC_SD_USER_%s_%s%s.service' % (
                pkg, prefix, service), user)


    def do_one_package(d, pkg):
        services = (d.getVar('OBMC_DBUS_SERVICES_%s' % pkg, True) or '').split()
        auto = (d.getVar('OBMC_DBUS_ACTIVATED_SERVICES_%s' % pkg, True) or '').split()

        for service in set(services).union(auto):
            prefix = 'dbus-' if service in auto else ''
            add_sd_user(d, prefix, service, pkg)
            add_sd_unit(d, prefix, service, pkg)
            add_dbus_config(d, service, pkg)
            if prefix:
                add_dbus_activation(d, service, pkg)

    pn = d.getVar('PN', True)
    if d.getVar('OBMC_DBUS_SERVICE_PACKAGES', True) is None:
        d.setVar('OBMC_DBUS_SERVICE_PACKAGES', pn)
        if d.getVar('OBMC_DBUS_SERVICES_%s' % pn, True) is None and \
                d.getVar('OBMC_DBUS_ACTIVATED_SERVICES_%s' % pn, True) is None:
            d.setVar('OBMC_DBUS_SERVICES_%s' % pn, pn)

    append_packages_to_base(
        d,
        'OBMC_DBUS_SERVICE_PACKAGES',
        'OBMC_SD_PACKAGES')
    foreach_list(
        d,
        'OBMC_DBUS_SERVICE_PACKAGES',
        do_one_package)
}


do_install_append() {
        # install the dbus configuration files
        [ -z "${_INSTALL_DBUS_CONFIGS}" ] || \
                install -d ${D}${dbus_system_confdir}
        for c in ${_INSTALL_DBUS_CONFIGS}; do
                install -m 0644 ${WORKDIR}/$c \
                        ${D}${dbus_system_confdir}$c
        done
        # install the dbus activation files
        [ -z "${_INSTALL_DBUS_ACTIVATIONS}" ] || \
                install -d ${D}${dbus_system_servicesdir}
        for s in ${_INSTALL_DBUS_ACTIVATIONS}; do
                install -m 0644 ${WORKDIR}/$s\
                        ${D}${dbus_system_servicesdir}$s
        done
}

addtask unit_defaults_and_properties after do_patch before do_configure
inherit obmc-systemd-policy
