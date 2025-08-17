{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";

    systems.url = "github:nix-systems/x86_64-linux";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (nixpkgs.legacyPackages.${system}) pkgs;
      in
      {
        devShells.default =
          (pkgs.buildFHSEnv {
            name = "p5-Kalaclista-env";
            targetPkgs =
              p: with p; [
                stdenv.cc.cc
                stdenv.cc.libc
                stdenv.cc.libc.dev

                gnumake
                pkg-config

                libidn
                libidn.dev
                libxcrypt
                openssl.dev

                perl
                perlPackages.Appcpanminus
                perlPackages.Appcpm
                perlPackages.locallib
              ];

            profile = ''
              eval "$(perl -I/usr/lib/perl5/site_perl/${pkgs.perl.version} -Mlocal::lib="$(pwd)/local")"
              export PERL_CPANM_OPT="-L $(pwd)/local"
              export PERL_CPANM_HOME="$(pwd)/local/.build"

              export LIBRARY_PATH=/usr/lib
              export CPATH=/usr/include
            '';
          }).env;
      }
    );
}
