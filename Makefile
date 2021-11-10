all:
	rm -f Makefile.log
	for f in xkb-ubuntu-20.04/symbols/??; do \
		./klfc $$f --from-xkb --keylayout ./ 2>>Makefile.log; \
		f_basename=$$(basename $$f); \
		sed -i "s/name=\"[^\"]\+\"/name=\"ysoftwareab xkb $${f_basename}\"/" $${f_basename}.keylayout; \
		mv $${f_basename}.keylayout y-xkb-$${f_basename}.keylayout; \
	done
	rm install-{user,system}.sh
