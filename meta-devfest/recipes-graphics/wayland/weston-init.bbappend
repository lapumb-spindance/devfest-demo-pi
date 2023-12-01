FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://weston.ini.real"

# Replace the default weston.ini with our own.
do_install:append() {
    install -d ${D}${sysconfdir}/xdg/weston
    install -D -p -m0644 ${WORKDIR}/weston.ini.real ${D}${sysconfdir}/xdg/weston/weston.ini
}

USERADD_PARAM:${PN} = "--home /home/weston --shell /bin/sh --user-group -G video,input,root weston"
GROUPADD_PARAM:${PN} = "-r wayland"
