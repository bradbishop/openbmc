# Shortcut for adding system users:
# OBMC_SYSTEM_USERS_PACKAGES ?= "${PN}"
# OBMC_SYSTEM_USERS_${PN} = "foo bar"

inherit obmc-phosphor-utils

OBMC_SYSTEM_USERS_PACKAGES ??= "${PN}"

python() {
    opts = ['--system', '--home', '/', '--no-create-home', '--shell /sbin/nologin', '--user-group']
    append_packages_to_base(
        d,
        'OBMC_SYSTEM_USERS_PACKAGES',
        'USERADD_PACKAGES')

    def do_one_package(d, pkg):
        cmds = []
        users = d.getVar('OBMC_SYSTEM_USERS_%s' % pkg, True)
        for u in (users or '').split():
            cmds.append(' '.join(opts + [u]))
        if cmds:
            d.appendVar('USERADD_PARAM_%s' % pkg, '%s' % (';'.join(cmds)))
        else:
            d.appendVar('USERADD_PARAM_%s' % pkg, ' ')

    foreach_list(d, 'OBMC_SYSTEM_USERS_PACKAGES', do_one_package)
}

inherit useradd
