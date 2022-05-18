JOBS = $(shell cat /proc/cpuinfo | grep processor | tail -n1 | cut -d\  -f2)
CWD = $(shell pwd)
SRC = $(shell pwd)

#	.PHONY: fetch-shopping fetch-shopping-domains fetch-website

#	fetch-shopping: entries-split
#		@perl -Ilib scripts/generates/fetch-shopping.pl $(SRC)/resources/_sources private/the.kalaclista.com/cache/shopping
#		@prettier -w private/the.kalaclista.com/cache/shopping/*.yaml

#	fetch-shopping-domains:
#		@pt -e '^\[[^\]]+\]\([^)]+\)$$' private/content | sed 's!./[^:]\+:[0-9]\+:!!' | sed 's![^]]\+](!!' | cut -d/ -f3 | sort -u | xargs -I{} echo 'qr<{}>,'

#	fetch-website: _build_source_split
#		@perl -Ilib scripts/generates/fetch-website.pl $(SRC)/resources/_content private/the.kalaclista.com/cache/website $(JOBS)

#	.PHONY: migrate-shopping

# 	migrate-shopping:
# 		@perl -Ilib scripts/migrate/affiliate.pl private/the.kalaclista.com/cache/shopping > private/the.kalaclista.com/data/affiliate.yaml

.PHONY: cpan2nix cpan2nix-dump cpan2nix-makenix cpan2nix-build

cpan2nix: \
	cpan2nix-dump \
	cpan2nix-makenix \
	cpan2nix-build

cpan2nix-dump:
	@perl scripts/cpan2nix/find-deps.pl

cpan2nix-makenix:
	@nix search "nixpkgs#perl"
	@cat resources/_cpan2nix/modules.txt | xargs -I{} perl scripts/cpan2nix/make-nix.pl {}

cpan2nix-build:
	@echo '{ pkgs, ... }: with pkgs; with perlPackages; let modules = rec {' >cpanfile.nix
	@find data/cpan2nix/ -type f -name '*.nix.txt' -exec cat {} \; >>cpanfile.nix
	@echo "}; in with modules; [ $(shell cat resources/_cpan2nix/modules.txt | sed 's/:://g') ]" >>cpanfile.nix
	@nixfmt cpanfile.nix 

test:
	@rm -f t/Kalaclista-*/fixture_*.png
	@prove -Ilib -j$(JOBS) t/*/*.t

.PHONY: shell
shell:
	@nix develop -c env SHELL=zsh zsh
