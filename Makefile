JOBS = $(shell nproc --all --ignore 1)

test:
	@rm -f t/Kalaclista-*/fixture_*.png
	@prove -Ilib -j$(JOBS) t/*/*.t

.PHONY: shell cpan update-cpanfile snapshot

shell:
	@cp /etc/nixos/flake.lock .
	@nix develop

cpan:
	@test ! -d extlib || rm -rf extlib
	@test ! -f cpanfile.snapshot || rm cpanfile.snapshot
	@cpm install -L extlib --home=$(HOME)/Applications/Development/cpm

update-cpanfile:
	@perl -Iextlib/lib/perl5 extlib/bin/update-cpanfile update | perl -lnpe 's<^- ([a-zA-Z0-9:]+)><- [$1](https://metacpan.org/pod/$1)>'

snapshot:
	@carton install --path extlib

