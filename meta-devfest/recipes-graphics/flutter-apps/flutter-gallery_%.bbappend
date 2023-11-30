inherit systemd

RDEPENDS:${PN} += "systemd"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://${BPN}.service"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} += "${PN}.service"
FILES:${PN} += "${systemd_unitdir}/system/${PN}.service"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/${PN}.service ${D}${systemd_unitdir}/system/
}
