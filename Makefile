XKB_VSN=2.42-1ubuntu1
XKB_DATA_DEB=xkb-data_${XKB_VSN}_all.deb
XKB_DATA_URL=http://ports.ubuntu.com/pool/main/x/xkeyboard-config/${XKB_DATA_DEB}
BUNDLE=ysoftwareab-xkb.bundle

all: ${XKB_DATA_DEB}
	rm -rf data.tar.zst tmp Makefile.log y-xkb-*.keylayout y-xkb-*.icns
	ar -x ${XKB_DATA_DEB}
	tar --zstd -xf data.tar.zst 2>/dev/null || tar xf data.tar.zst
	rm -f debian-binary control.tar.zst data.tar.zst
	( used_ids=(); \
		for f in usr/share/X11/xkb/symbols/?? usr/share/X11/xkb/symbols/{ara,epo,latam,mao}; do \
		f_basename=$$(basename $$f); \
		[[ "$$f_basename" != "pc" ]] || continue; \
		for g in $$(cat $$f | grep "^xkb_symbols" | sed "s/^xkb_symbols \+\"\([^\"]\+\)\".*/\1/"); do \
			./klfc --from-xkb "$$f($$g)" --keylayout ./tmp; \
			g_suffix="-$$g"; \
			[[ "$$g" != "basic" ]] || g_suffix=; \
			h=$$(printf '%s' "$${f_basename}$${g_suffix}" | cksum | cut -d' ' -f1); \
			id=$$(( (h % 32766) + 2 )); \
			while [[ -n "$${used_ids[$$id]:-}" ]]; do id=$$(( (id % 32766) + 2 )); done; \
			used_ids[$$id]=1; \
			echo y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			mv tmp/$${f_basename}$${g_suffix}.keylayout y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			sed -i "s/id=\"-1337\"/id=\"-$${id}\"/" y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			sed -i "s/name=\"[^\"]\+\"/name=\"ysoftwareab xkb $${f_basename}$${g_suffix}\"/" y-xkb-$${f_basename}$${g_suffix}.keylayout; \
		done; \
	done ) 2>>Makefile.log
	patch --forward y-xkb-ro.keylayout < macos-emacs-bindings-ro.patch
	patch --forward y-xkb-se.keylayout < macos-emacs-bindings-se.patch
	rm -f macos-emacs-bindings-*.rej
	rm -rf tmp
	./generate-icons.sh

icons:
	./generate-icons.sh

bundle:
	rm -rf ${BUNDLE}
	mkdir -p ${BUNDLE}/Contents/Resources
	printf '%s\n' \
		'<?xml version="1.0" encoding="UTF-8"?>' \
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
		'<plist version="1.0">' \
		'<dict>' \
		'	<key>CFBundleIdentifier</key>' \
		'	<string>se.ysoftwareab.xkb-for-macos</string>' \
		'	<key>CFBundleName</key>' \
		'	<string>ysoftwareab xkb</string>' \
		'	<key>CFBundleVersion</key>' \
		'	<string>${XKB_VSN}</string>' \
		'	<key>CFBundleShortVersionString</key>' \
		'	<string>${XKB_VSN}</string>' \
		'	<key>CFBundleInfoDictionaryVersion</key>' \
		'	<string>6.0</string>' \
		'	<key>CFBundlePackageType</key>' \
		'	<string>BNDL</string>' \
		'</dict>' \
		'</plist>' > ${BUNDLE}/Contents/Info.plist
	cp -f y-xkb-*.keylayout y-xkb-*.icns ${BUNDLE}/Contents/Resources/

${XKB_DATA_DEB}:
	curl -O ${XKB_DATA_URL}

clean:
	rm -rf usr/ etc/ tmp ${BUNDLE} *.deb Makefile.log *.rej *.orig \#*
