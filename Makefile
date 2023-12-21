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
	@test ! -f cpanfile.snapshot || rm cpanfile.snapshot
	@cpm install -L extlib --home=$(HOME)/Applications/Development/cpm

snapshot:
	@carton install --path extlib
