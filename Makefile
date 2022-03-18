JOBS = $(shell cat /proc/cpuinfo | grep processor | tail -n1 | cut -d\  -f2)
CWD = $(shell pwd)
SRC = /tmp/the-kalaclista-com-v5

.PHONY: \
	entries-split \
	entries-sitemap

build: entries-split
	$(MAKE) -j $(JOBS) ENV=production \
		entries-sitemap

entries-split:
	@rm -rf $(SRC)/resources/_sources
	@perl -Ilib scripts/entries/split-frontmatter.pl $(SRC)/resources/_sources private/content

entries-sitemap:
	@perl -Ilib scripts/entries/make-sitemap_xml.pl $(SRC)/resources/_sources dist/sitemap.xml

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

.PHONY: t xt

t:
	@prove -Ilib -j$(JOBS) t/*/*.t

xt: build
	@prove -Ilib -j$(JOBS) xt/*.t

.PHONY: shell
shell:
	@nix develop -c env SHELL=zsh zsh
