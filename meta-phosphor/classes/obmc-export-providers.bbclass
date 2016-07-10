python() {
    for dashpath, spec in (d.getVarFlags('OBMC_DBUS_PROVIDERS') or {}).items():
        recipe, service = spec.split(':')

        d.setVar('PREFERRED_PROVIDER_virtual/%s' % dashpath, recipe)
}
