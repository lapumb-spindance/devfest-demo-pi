do_install:append() {
    install -d ${D}${libdir}
    install -m 0644 ${D}${datadir}/flutter/${FLUTTER_SDK_VERSION}/release/lib/libflutter_engine.so ${D}${libdir}/libflutter_engine.so
}

FILES:${PN} += "${libdir}/libflutter_engine.so"
