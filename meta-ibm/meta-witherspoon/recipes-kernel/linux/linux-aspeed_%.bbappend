FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append_ibm-ac-server = " file://witherspoon.cfg"
SRC_URI_append_mihawk = " file://mihawk.cfg"
SRC_URI_append_witherspoon-128 = " file://0001-ARM-dts-Aspeed-Witherspoon-128-Update-BMC-partitioni.patch"
SRC_URI_append_rainier = " \
    file://0001-arm-dts-aspeed-g6-add-a-g5-spi-ip-block.patch \
    file://0002-i2c-Aspeed-Add-AST2600-compatible.patch \
    file://0003-ARM-dts-Aspeed-Add-I2C-busses-to-AST2600-and-Tacoma.patch \
    file://0004-arm-dts-aspeed-add-Rainier-system.patch \
    file://rainier.cfg \
    "
