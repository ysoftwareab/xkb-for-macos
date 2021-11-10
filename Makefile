XKB_VSN=2.29-2
XKB_DATA_DEB=xkb-data_${XKB_VSN}_all.deb
XKB_DATA_URL=http://ports.ubuntu.com/pool/main/x/xkeyboard-config/${XKB_DATA_DEB}

all: ${XKB_DATA_DEB}
	ar -x ${XKB_DATA_DEB} ./data.tar.xz
	tar xvf data.tar.xz
	rm data.tar.xz
	rm -f Makefile.log
	for f in usr/share/X11/xkb/symbols/??; do \
		./klfc $$f --from-xkb --keylayout ./ 2>>Makefile.log; \
		f_basename=$$(basename $$f); \
		sed -i "s/name=\"[^\"]\+\"/name=\"ysoftwareab xkb $${f_basename}\"/" $${f_basename}.keylayout; \
		mv $${f_basename}.keylayout y-xkb-$${f_basename}.keylayout; \
	done
	rm install-{user,system}.sh

${XKB_DATA_DEB}:
	curl -O ${XKB_DATA_URL}
