all:
	rm -f Makefile.log
	for f in xkb-ubuntu-20.04/symbols/??; do \
		./klfc $$f --from-xkb --keylayout ./ 2>>Makefile.log; \
	done
	rm install-{user,system}.sh
