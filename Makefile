all:
	for f in xkb-ubuntu-20.04/symbols/??; do \
		./klfc $$f --from-xkb --keylayout ./; \
		rm install-{user,system}.sh; \
	done
