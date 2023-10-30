{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/master"; };
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell.${system} = with pkgs;
        (buildFHSUserEnv rec {
          name = "p5-Kalaclista";
          targetPkgs = p:
            with p; [
              cmark
              coreutils
              glibc.dev
              gnumake
              libxcrypt
              openssl.dev
              perl
              perlPackages.Appcpanminus
              perlPackages.Appcpm
              perlPackages.Carton
              perlPackages.locallib
              pkg-config
              stdenv.cc.cc
              stdenv.cc.libc
            ];

          runScript = writeShellScript "start.sh" ''
            export PATH=$(pwd)/extlib/bin:$PATH
            export PERL5LIB=$(pwd)/extlib/lib/perl5:$(pwd)/app/lib:$(pwd)/lib

            export CFLAGS=-I/usr/include
            export CXXFLAGS=-I/usr/include
            export CPPFLAGS=-I/usr/include

            unset IN_NIX_SHELL
            export IN_PERL_SHELL=1

            exec zsh "''${@}"
          '';
        }).env;
    };
}
