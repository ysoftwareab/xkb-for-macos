XKB_VSN=2.42-1ubuntu1
XKB_DATA_DEB=xkb-data_${XKB_VSN}_all.deb
XKB_DATA_URL=http://ports.ubuntu.com/pool/main/x/xkeyboard-config/${XKB_DATA_DEB}

all: ${XKB_DATA_DEB}
	rm -rf data.tar.zst tmp Makefile.log y-xkb-*.keylayout
	ar -x ${XKB_DATA_DEB}
	tar --zstd -xf data.tar.zst 2>/dev/null || tar xf data.tar.zst
	rm -f debian-binary control.tar.zst data.tar.zst
	( id=1; \
		for f in usr/share/X11/xkb/symbols/??; do \
		for g in $$(cat $$f | grep "^xkb_symbols" | sed "s/^xkb_symbols \+\"\([^\"]\+\)\".*/\1/"); do \
			./klfc --from-xkb "$$f($$g)" --keylayout ./tmp; \
			f_basename=$$(basename $$f); \
			g_suffix="-$$g"; \
			[[ "$$g" != "basic" ]] || g_suffix=; \
			echo y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			mv tmp/$${f_basename}$${g_suffix}.keylayout y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			sed -i "s/id=\"-1337\"/id=\"$${id}\"/" y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			sed -i "s/name=\"[^\"]\+\"/name=\"ysoftwareab xkb $${f_basename}$${g_suffix} id=$${id}\"/" y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			id=$$((id+1)); \
		done; \
	done ) 2>>Makefile.log
	patch --forward y-xkb-ro.keylayout < macos-emacs-bindings-ro.patch
	patch --forward y-xkb-se.keylayout < macos-emacs-bindings-se.patch
	rm -f macos-emacs-bindings-*.rej
	rm -rf tmp

${XKB_DATA_DEB}:
	curl -O ${XKB_DATA_URL}

clean:
	rm -rf usr/ tmp *.deb Makefile.log *.rej *.orig \#*
