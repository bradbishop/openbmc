# Helper functions for checking feature variables.

inherit utils

def df_enabled(feature, value, d):
    return base_contains("DISTRO_FEATURES", feature, value, "", d)

def mf_enabled(feature, value, d):
    return base_contains("MACHINE_FEATURES", feature, value, "", d)

def cf_enabled(feature, value, d):
    return value if df_enabled(feature, value, d) \
        and mf_enabled(feature, value, d) \
            else ""

def append_packages_to_base(d, pkg_var, base_var):
    pkgs = (d.getVar(pkg_var, True) or '').split()
    base_pkgs = (d.getVar(base_var, True) or '').split()
    add_pkgs = set(pkgs).difference(base_pkgs)

    if add_pkgs:
        d.appendVar(base_var, ' %s' % (' '.join(add_pkgs)))

def foreach_list(d, list_var, callback, *a, **kw):
    array = d.getVar(list_var, True)
    for item in (array or '').split():
        callback(d, item, *a, **kw)

def get_obmc_providers(d):
    all = (d.getVarFlags('OBMC_DBUS_PROVIDERS') or {}).keys()
    mine = (d.getVar('PROVIDES', True) or "").replace('virtual/', '').split()
    providers = set(all).intersection(mine)
    map = {}
    for dashpath in providers:
        recipe, service = (
            d.getVarFlag('OBMC_DBUS_PROVIDERS', dashpath, True) or "").split(':')
	map['/' + dashpath.replace('-', '/')] = (recipe, service)

    return map
