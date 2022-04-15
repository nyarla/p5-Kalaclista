JOBS = $(shell cat /proc/cpuinfo | grep processor | tail -n1 | cut -d\  -f2)
CWD = $(shell pwd)
SRC = /tmp/the-kalaclista-com-v5

.PHONY: build clean

_build_distdir:
	@test -d dist/the.kalaclista.com || mkdir -p dist/the.kalaclista.com

_build_distdir_static: _build_distdir
	@cp -R private/the.kalaclista.com/assets/static/* dist/the.kalaclista.com/

_build_source_split:
	@perl -Ilib bin/kalaclista.pl production split

_build_dist_sitemap_xml:
	@perl -Ilib bin/kalaclista.pl production sitemap

build: clean \
	_build_distdir \
	_build_distdir_static \
	_build_source_split \
	_build_dist_sitemap_xml

clean:
	@rm -rf dist/the.kalaclista.com

.PHONY: fetch-shopping fetch-shopping-domains fetch-website

fetch-shopping: entries-split
	@perl -Ilib scripts/generates/fetch-shopping.pl $(SRC)/resources/_sources private/the.kalaclista.com/cache/shopping
	@prettier -w private/the.kalaclista.com/cache/shopping/*.yaml

fetch-shopping-domains:
	@pt -e '^\[[^\]]+\]\([^)]+\)$$' private/content | sed 's!./[^:]\+:[0-9]\+:!!' | sed 's![^]]\+](!!' | cut -d/ -f3 | sort -u | xargs -I{} echo 'qr<{}>,'

fetch-website: entries-split
	@perl -Ilib scripts/generates/fetch-website.pl $(SRC)/resources/_sources private/cache/website $(JOBS)

.PHONY: cpan2nix cpan2nix-dump cpan2nix-makenix cpan2nix-build

cpan2nix: \
	cpan2nix-dump \
	cpan2nix-makenix \
	cpan2nix-build

cpan2nix-dump:
	@perl scripts/cpan2nix/find-deps.pl

cpan2nix-makenix:
	@cat resources/_cpan2nix/modules.txt | xargs -P$(JOBS) -I{} perl scripts/cpan2nix/make-nix.pl {}

cpan2nix-build:
	@echo '{ pkgs, ... }: with pkgs; with perlPackages; let modules = rec {' >cpanfile.nix
	@find data/cpan2nix/ -type f -name '*.nix.txt' -exec cat {} \; >>cpanfile.nix
	@echo "}; in with modules; [ $(shell cat resources/_cpan2nix/modules.txt | sed 's/:://g') ]" >>cpanfile.nix

.PHONY: test t xt

test: t xt

t:
	@rm -f t/Kalaclista-*/fixture_*.png
	@prove -Ilib -j$(JOBS) t/*/*.t

xt: build
	@prove -Ilib -j$(JOBS) xt/*/*.t

.PHONY: shell
shell:
	@nix develop -c env SHELL=zsh zsh

.PHONY: migrate-shopping

migrate-shopping:
	@perl -Ilib scripts/migrate/affiliate.pl private/the.kalaclista.com/cache/shopping > private/the.kalaclista.com/data/affiliate.yaml
