JOBS = $(shell nproc --all --ignore 1)

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
	@nix develop -c env SHELL=zsh sh -c 'env PERL5LIB=$(shell pwd)/lib:$$PERL5LIB zsh'
