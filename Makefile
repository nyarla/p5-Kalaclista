JOBS = $(shell nproc --all --ignore 1)

.PHONY: install test shell

install:
	cpm install -Llocal --home=$(shell pwd)/local/.cpm --show-build-log-on-failure

test:
	prove -j$(JOBS) -Ilocal/lib/perl5 -Ilib -It/lib -vr t/

shell:
	@nix develop
