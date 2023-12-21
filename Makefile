JOBS = $(shell nproc --all --ignore 1)

test:
	@rm -f t/Kalaclista-*/fixture_*.png
	@prove -Ilib -j$(JOBS) t/*/*.t

.PHONY: shell

shell:
	@cp /etc/nixos/flake.lock .
	@nix develop

cpan:
	@test ! -d extlib || rm -rf extlib
	@cpm install -L extlib --home=$(HOME)/Applications/Development/cpm --with-develop
