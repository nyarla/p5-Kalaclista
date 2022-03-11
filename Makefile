JOBS = $(shell cat /proc/cpuinfo | grep processor | tail -n1 | cut -d\  -f2)
CWD = $(shell pwd)

.PHONY: _entries_split

_entries_split:
	@rm -rf resources/_sources
	perl -Ilib scripts/entries/split-frontmatter.pl $(JOBS)

.PHONY: cpan2nix _cpan2nix-dump_dependences _cpan2nix-make_nix _cpan2nix-packing
cpan2nix: 	_cpan2nix-dump_dependences \
			_cpan2nix-make_nix \
			_cpan2nix-packing

_cpan2nix-dump_dependences:
	@perl scripts/cpan2nix/find-deps.pl

_cpan2nix-make_nix:
	@cat resources/_cpan2nix/modules.txt | xargs -P$(JOBS) -I{} perl scripts/cpan2nix/make-nix.pl {}

_cpan2nix-packing:
	@echo '{pkgs,...}: with pkgs; pkgs.lib.attrValues (with perlPackages; rec {' >cpanfile.nix
	(find data/cpan2nix/ -type f -name '*.nix.txt' | perl scripts/cpan2nix/filter-cpan-nix.pl ) >>cpanfile.nix
	@echo '})' >>cpanfile.nix
	@nixfmt cpanfile.nix

.PHONY: shell
shell:
	@nix develop -c env SHELL=zsh zsh
