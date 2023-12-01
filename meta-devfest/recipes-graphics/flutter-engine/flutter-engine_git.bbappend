# Install the Flutter engine in /usr/lib so there is no need to set the LD_LIBRARY at runtime.
do_install:append() {
    install -d ${D}${libdir}
    install -m 0644 ${D}${datadir}/flutter/${FLUTTER_SDK_VERSION}/release/lib/libflutter_engine.so ${D}${libdir}/libflutter_engine.so
}

FILES:${PN} += "${libdir}/libflutter_engine.so"
