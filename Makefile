XKB_VSN=2.29-2
XKB_DATA_DEB=xkb-data_${XKB_VSN}_all.deb
XKB_DATA_URL=http://ports.ubuntu.com/pool/main/x/xkeyboard-config/${XKB_DATA_DEB}

all: ${XKB_DATA_DEB}
	ar -x ${XKB_DATA_DEB} ./data.tar.xz
	tar xvf data.tar.xz
	rm -rf data.tar.xz tmp Makefile.log
	( for f in usr/share/X11/xkb/symbols/??; do \
		for g in $$(cat $$f | grep "^xkb_symbols" | sed "s/^xkb_symbols \+\"\([^\"]\+\)\".*/\1/"); do \
			./klfc --from-xkb "$$f($$g)" --keylayout ./tmp; \
			f_basename=$$(basename $$f); \
			g_suffix="-$$g"; \
			[[ "$$g" != "basic" ]] || g_suffix=; \
			echo y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			mv tmp/$${f_basename}$${g_suffix}.keylayout y-xkb-$${f_basename}$${g_suffix}.keylayout; \
			sed -i "s/name=\"[^\"]\+\"/name=\"ysoftwareab xkb $${f_basename}$${g_suffix}\"/" y-xkb-$${f_basename}$${g_suffix}.keylayout; \
		done; \
	done ) 2>>Makefile.log
	rm -rf tmp

${XKB_DATA_DEB}:
	curl -O ${XKB_DATA_URL}
