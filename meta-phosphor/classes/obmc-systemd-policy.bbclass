# Add the specified or default policy to systemd service files.
#  OBMC_SD_PACKAGES ?= "${PN}"
#    The list of packages to which policy should be applied.
#
#  OBMC_SD_UNITS_${PN} ?= "${PN}.service"
#    A list of systemd unit files.  The class will add the unit
#    file to the package.  Default to ${PN}.service.
#
#  OBMC_SD_RESTART_POLICY_${PN}_${PN}.service ?= "always"
#    The restart policy for the unit.  Default to always.
#
#  OBMC_SD_INSTALL_TARGET_${PN}_${PN}.service ?= "obmc-startup"
#    The wantedby field in in the install section.  Default
#    to obmc-startup.  The magic string '%%skip%%' can be used
#    to inhibit adding the wantedby field.
#
#  OBMC_SD_USER_${PN}_${PN}.service ?= "root"
#    The user for service files.  The class will add the user
#    to the unit file and to the image via useradd.  Default
#    to root.  The magic string '%%skip%%' can be used to
#    inhibit user creation.

inherit obmc-phosphor-utils

_INSTALL_SD_UNITS=""


def update_unit_file(d, unit_pkg, callbacks, *a, **kw):
    import ConfigParser
    (unit, pkg) = unit_pkg.split(':')
    path = d.getVar('WORKDIR', True)
    if not os.path.isfile('%s/%s' % (path, unit)):
        bb.warn('unit file "%s" does not exist' % unit)
        return
    parser = ConfigParser.SafeConfigParser()
    parser.optionxform = str
    parser.read('%s/%s' % (path, unit))

    for callback in callbacks:
        callback(d, pkg, unit, parser, *a, **kw)

    with open('%s/%s' % (path, unit), 'w+') as fd:
        parser.write(fd)
        fd.close()


python do_add_unit_properties() {
    def add_user(d, pkg, unit, parser):
        user = d.getVar(
            'OBMC_SD_USER_%s_%s' % (pkg, unit), True)
        if user == '%%skip%%':
            return
        if not parser.has_section('Service'):
            parser.add_section('Service')
        if not parser.has_option('Service', 'User'):
            parser.set(
                'Service', 'User', user or 'root')


    def add_restart_policy(d, pkg, unit, parser):
        restart = d.getVar(
            'OBMC_SD_RESTART_POLICY_%s_%s' % (pkg, unit), True)
        if restart == '%%skip%%':
            return
        if not parser.has_section('Service'):
            parser.add_section('Service')
        if not parser.has_option('Service', 'Restart'):
            parser.set(
                'Service', 'Restart', restart or 'always')


    def add_install_target(d, pkg, unit, parser):
        wb = d.getVar(
            'OBMC_SD_INSTALL_TARGET_%s_%s' % (pkg, unit), True)
        if wb == '%%skip%%':
            return
        if not parser.has_section('Install'):
            parser.add_section('Install')
        if not parser.has_option('Install', 'WantedBy'):
            parser.set(
                'Install', 'WantedBy', '%s.target' % (
                    wb or 'obmc-startup'))


    foreach_list(
        d,
        '_UPDATE_SD_UNITS',
        update_unit_file,
        [ add_install_target,
            add_restart_policy,
            add_user])
}


python() {
    def add_sd_unit(d, unit, pkg):
        searchpaths = d.getVar('FILESPATH', True)
        path = bb.utils.which(searchpaths, '%s' % unit)
        if not os.path.isfile(path):
            bb.fatal('Did not find unit file "%s"' % unit)
        d.appendVar('SRC_URI', ' file://%s' % unit)
        d.appendVar('FILES_%s' % pkg, ' %s/%s' \
            % (d.getVar('systemd_system_unitdir', True), unit))
        d.appendVar('_UPDATE_SD_UNITS', ' %s:%s' % (unit, pkg))
        d.appendVar('SYSTEMD_SERVICE_%s' % pkg, ' %s' % unit)


    def add_sd_user(d, unit, pkg):
        user = d.getVar(
            'OBMC_SD_USER_%s_%s' % (pkg, unit), True)
        if user:
            d.appendVar('OBMC_SYSTEM_USERS_%s' % pkg, ' %s' % user)


    def do_one_unit(d, unit, pkg):
        add_sd_unit(d, unit, pkg)
        add_sd_user(d, unit, pkg)


    def foreach_unit(d, pkg):
        foreach_list(
            d,
            'OBMC_SD_UNITS_%s' % pkg,
            do_one_unit,
            pkg)

    pn = d.getVar('PN', True)
    if d.getVar('OBMC_SD_PACKAGES', True) is None:
        d.setVar('OBMC_SD_PACKAGES', pn)
        if d.getVar('OBMC_SD_UNITS_%s' % pn, True) is None:
            d.setVar('OBMC_SD_UNITS_%s' % pn, '%s.service' % pn)

    append_packages_to_base(
        d,
        'OBMC_SD_PACKAGES',
        'SYSTEMD_PACKAGES')
    append_packages_to_base(
        d,
        'OBMC_SD_PACKAGES',
        'OBMC_SYSTEM_USERS_PACKAGES')
    foreach_list(
        d,
        'OBMC_SD_PACKAGES',
        foreach_unit)

    unit_pkgs = (d.getVar('_UPDATE_SD_UNITS', True) or '').split()
    install_units = [x.split(':')[0] for x in unit_pkgs]
    d.setVar('_INSTALL_SD_UNITS', ' '.join(install_units))
}


do_install_append() {
        [ -z "${_INSTALL_SD_UNITS}" ] || \
                install -d ${D}${systemd_system_unitdir}
        for s in "${_INSTALL_SD_UNITS}"; do
                install -m 0644 ${WORKDIR}/$s \
                        ${D}${systemd_system_unitdir}/$s
                sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
                        -e 's,@BINDIR@,${bindir},g' \
                        -e 's,@SBINDIR@,${sbindir},g' \
                        ${D}${systemd_system_unitdir}/$s
        done
}


addtask add_unit_properties after do_patch before do_configure
inherit systemd
inherit system-user
