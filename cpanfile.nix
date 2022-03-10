{ pkgs, ... }:
with pkgs;
pkgs.lib.attrValues (with perlPackages; rec {
  ParallelForkBossWorkerAsync = buildPerlPackage {
    pname = "Parallel-Fork-BossWorkerAsync";
    version = "0.09";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/J/JV/JVANNUCCI/Parallel-Fork-BossWorkerAsync-0.09.tar.gz";
      sha256 =
        "76481f21fac3663d357fa369e70cae43e47274d34cf0924d563a3c438c7989a4";
    };
    meta = {
      description =
        "Perl extension for creating asynchronous forking queue processing applications";
    };
  };
})
