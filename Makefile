JOBS = $(shell nproc --all --ignore 1)

test:
	@rm -f t/Kalaclista-*/fixture_*.png
	@prove -j$(JOBS) -Iextlib/lib/perl5 -Ilib -It/lib -vr t/

.PHONY: shell

shell:
	@cp /etc/nixos/flake.lock .
	@nix develop

cpan:
	@test ! -d extlib || rm -rf extlib
	@cpm install -L extlib --home=$(HOME)/Applications/Development/cpm --with-develop

snapshot:
	@carton install --path extlib

cpanfile:
	@test ! -f cpanfile.snapshot || rm cpanfile.snapshot
	@$(MAKE) snapshot
	@carton exec update-cpanfile update
