{ pkgs, ... }:
with pkgs;
pkgs.lib.attrValues (with perlPackages; rec {
  TestWarn = buildPerlPackage {
    pname = "Test-Warn";
    version = "0.36";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BIGJ/Test-Warn-0.36.tar.gz";
      sha256 =
        "ecbca346d379cef8d3c0e4ac0c8eb3b2613d737ffaaeae52271c38d7bf3c6cda";
    };
    propagatedBuildInputs = [ SubUplevel ];
    meta = {
      description = "Perl extension to test methods for warnings";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPCheck = buildPerlPackage {
    pname = "B-Hooks-OP-Check";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz";
      sha256 =
        "c7b5d1bef59ef9087ff67eb3168d2624be94ae5464469e259ad11bfb8ad8cdcd";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      homepage = "https://github.com/karenetheridge/B-Hooks-OP-Check";
      description = "Wrap OP check callbacks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubInfo = buildPerlPackage {
    pname = "Sub-Info";
    version = "0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Sub-Info-0.002.tar.gz";
      sha256 =
        "ea3056d696bdeff21a99d340d5570887d39a8cc47bff23adfc82df6758cdd0ea";
    };
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Tool for inspecting subroutines";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuild = buildPerlPackage {
    pname = "Module-Build";
    version = "0.4231";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz";
      sha256 =
        "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717";
    };
    meta = {
      description = "Build and install Perl modules";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLeakTrace = buildPerlPackage {
    pname = "Test-LeakTrace";
    version = "0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEEJO/Test-LeakTrace-0.17.tar.gz";
      sha256 =
        "777d64d2938f5ea586300eef97ef03eacb43d4c1853c9c3b1091eb3311467970";
    };
    meta = {
      homepage = "https://metacpan.org/release/Test-LeakTrace";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNeeds = buildPerlPackage {
    pname = "Test-Needs";
    version = "0.002009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Test-Needs-0.002009.tar.gz";
      sha256 =
        "571c21193ad16195df58b06b268798796a391b398c443271721d2cc0fb7c4ac3";
    };
    meta = {
      description = "Skip tests when modules not available";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moo = buildPerlPackage {
    pname = "Moo";
    version = "2.005004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Moo-2.005004.tar.gz";
      sha256 =
        "e3030b80bd554a66f6b3c27fd53b1b5909d12af05c4c11ece9a58f8d1e478928";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers RoleTiny SubQuote ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatibility)";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Test2Suite = buildPerlPackage {
    pname = "Test2-Suite";
    version = "0.000145";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test2-Suite-0.000145.tar.gz";
      sha256 =
        "ed44be739c8879fe178d3107b238f2db960d52797db0058de53be5b84600358b";
    };
    propagatedBuildInputs =
      [ Importer ScopeGuard SubInfo TermTable ModulePluggable ];
    meta = {
      description =
        "Distribution with a rich set of tools built upon the Test2 framework";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListMoreUtils = buildPerlPackage {
    pname = "List-MoreUtils";
    version = "0.430";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz";
      sha256 =
        "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527";
    };
    buildInputs = [ TestLeakTrace ];
    propagatedBuildInputs = [ ExporterTiny ListMoreUtilsXS ];
    meta = {
      homepage = "https://metacpan.org/release/List-MoreUtils";
      description = "Provide the stuff missing in List::Util";
      license = lib.licenses.asl20;
    };
  };

  indirect = buildPerlPackage {
    pname = "indirect";
    version = "0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/indirect-0.39.tar.gz";
      sha256 =
        "71733c4c348e98fdd575b44a52042428c39888a18c25656efe59ef3d7d0d27e5";
    };
    meta = {
      homepage = "http://search.cpan.org/dist/indirect/";
      description =
        "Lexically warn about using the indirect method call syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorLite = buildPerlPackage {
    pname = "Class-Accessor-Lite";
    version = "0.08";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz";
      sha256 =
        "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a";
    };
    meta = {
      description = "A minimalistic variant of Class::Accessor";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodModifiers = buildPerlPackage {
    pname = "Class-Method-Modifiers";
    version = "2.13";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.13.tar.gz";
      sha256 =
        "ab5807f71018a842de6b7a4826d6c1f24b8d5b09fcce5005a3309cf6ea40fd63";
    };
    buildInputs = [ TestFatal TestNeeds ];
    meta = {
      homepage = "https://github.com/moose/Class-Method-Modifiers";
      description = "Provides Moose-like method modifiers";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  multidimensional = buildPerlPackage {
    pname = "multidimensional";
    version = "0.014";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/I/IL/ILMARI/multidimensional-0.014.tar.gz";
      sha256 =
        "12eb14317447bd15ab9799677db9eda20e784d8b113e44a5f6f11f529e862c5f";
    };
    buildInputs = [ ExtUtilsDepends ];
    propagatedBuildInputs = [ BHooksOPCheck ];
    meta = {
      homepage = "https://github.com/ilmari/multidimensional";
      description = "Disables multidimensional array emulation";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPerl = buildPerlPackage {
    pname = "Data-Perl";
    version = "0.002011";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TOBYINK/Data-Perl-0.002011.tar.gz";
      sha256 =
        "8d34dbe314cfa2d99bd9aae546bbde94c38bb05b74b07c89bde1673a6f6c55f4";
    };
    buildInputs = [ TestDeep TestFatal TestOutput ];
    propagatedBuildInputs =
      [ ClassMethodModifiers ListMoreUtils ModuleRuntime RoleTiny strictures ];
    meta = {
      homepage = "https://github.com/tobyink/Data-Perl";
      description = "Base classes wrapping fundamental Perl data types";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestException = buildPerlPackage {
    pname = "Test-Exception";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-Exception-0.43.tar.gz";
      sha256 =
        "156b13f07764f766d8b45a43728f2439af81a3512625438deab783b7883eb533";
    };
    propagatedBuildInputs = [ SubUplevel ];
    meta = {
      homepage = "https://github.com/Test-More/test-exception";
      description = "Test exception-based code";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntime = buildPerlPackage {
    pname = "Module-Runtime";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz";
      sha256 =
        "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024";
    };
    meta = {
      description = "Runtime module handling";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BCOW = buildPerlPackage {
    pname = "B-COW";
    version = "0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/B-COW-0.004.tar.gz";
      sha256 =
        "fcafb775ed84a45bc2c06c5ffd71342cb3c06fb0bdcd5c1b51b0c12f8b585f51";
    };
    meta = {
      description = "B::COW additional B helpers to check COW status";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestDeep = buildPerlPackage {
    pname = "Test-Deep";
    version = "1.130";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-1.130.tar.gz";
      sha256 =
        "4064f494f5f62587d0ae501ca439105821ee5846c687dc6503233f55300a7c56";
    };
    meta = {
      homepage = "http://github.com/rjbs/Test-Deep/";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TryTiny = buildPerlPackage {
    pname = "Try-Tiny";
    version = "0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz";
      sha256 =
        "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be";
    };
    meta = {
      homepage = "https://github.com/p5sagit/Try-Tiny";
      description = "Minimal try/catch with proper preservation of $@";
      license = lib.licenses.mit;
    };
  };

  CaptureTiny = buildPerlPackage {
    pname = "Capture-Tiny";
    version = "0.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz";
      sha256 =
        "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19";
    };
    meta = {
      homepage = "https://github.com/dagolden/Capture-Tiny";
      description =
        "Capture STDOUT and STDERR from Perl, XS or external programs";
      license = lib.licenses.asl20;
    };
  };

  PathTiny = buildPerlPackage {
    pname = "Path-Tiny";
    version = "0.122";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.122.tar.gz";
      sha256 =
        "4bc6f76d0548ccd8b38cb66291a885bf0de453d0167562c7b82e8861afdcfb7c";
    };
    meta = {
      homepage = "https://github.com/dagolden/Path-Tiny";
      description = "File path utility";
      license = lib.licenses.asl20;
    };
  };

  TermTable = buildPerlPackage {
    pname = "Term-Table";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Term-Table-0.016.tar.gz";
      sha256 =
        "8fb4fbb8e96a2d6c514949eb8cfd7e66319bcb1cbf7cea0ab19af887a72d97bf";
    };
    propagatedBuildInputs = [ Importer ];
    meta = {
      description = "Format a header and rows into a table";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleTiny = buildPerlPackage {
    pname = "Role-Tiny";
    version = "2.002004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz";
      sha256 =
        "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45";
    };
    meta = {
      description = "Roles: a nouvelle cuisine portion size slice of Moose";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubUplevel = buildPerlPackage {
    pname = "Sub-Uplevel";
    version = "0.2800";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.2800.tar.gz";
      sha256 =
        "b4f3f63b80f680a421332d8851ddbe5a8e72fcaa74d5d1d98f3c8cc4a3ece293";
    };
    meta = {
      homepage = "https://github.com/Perl-Toolchain-Gang/Sub-Uplevel";
      description = "Apparently run a function in a higher stack frame";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListMoreUtilsXS = buildPerlPackage {
    pname = "List-MoreUtils-XS";
    version = "0.430";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz";
      sha256 =
        "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242";
    };
    meta = {
      homepage = "https://metacpan.org/release/List-MoreUtils-XS";
      description = "Provide the stuff missing in List::Util in XS";
      license = lib.licenses.asl20;
    };
  };

  MooXTypesMooseLike = buildPerlPackage {
    pname = "MooX-Types-MooseLike";
    version = "0.29";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-0.29.tar.gz";
      sha256 =
        "1d3780aa9bea430afbe65aa8c76e718f1045ce788aadda4116f59d3b7a7ad2b4";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Some Moosish types and a type builder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestOutput = buildPerlPackage {
    pname = "Test-Output";
    version = "1.033";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-Output-1.033.tar.gz";
      sha256 =
        "f6a8482740b075fad22aaf4d987d38ef927c6d2b452d4ae0d0bd8f779830556e";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      homepage = "https://github.com/briandfoy/test-output";
      description = "Utilities to test STDOUT and STDERR messages";
      license = lib.licenses.artistic2;
    };
  };

  YAMLTiny = buildPerlPackage {
    pname = "YAML-Tiny";
    version = "1.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz";
      sha256 =
        "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744";
    };
    meta = {
      homepage = "https://github.com/Perl-Toolchain-Gang/YAML-Tiny";
      description = "Read/Write YAML files with as little code as possible";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  barewordfilehandles = buildPerlPackage {
    pname = "bareword-filehandles";
    version = "0.007";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/I/IL/ILMARI/bareword-filehandles-0.007.tar.gz";
      sha256 =
        "4134533716d87af8fff56e250c488ad06df0a7bff48e7cf7de63ff6bc8d9c17f";
    };
    buildInputs = [ ExtUtilsDepends ];
    propagatedBuildInputs = [ BHooksOPCheck ];
    meta = {
      homepage = "https://github.com/ilmari/bareword-filehandles";
      description = "Disables bareword filehandles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubQuote = buildPerlPackage {
    pname = "Sub-Quote";
    version = "2.006006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz";
      sha256 =
        "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Efficient generation of subroutines via string eval";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggable = buildPerlPackage {
    pname = "Module-Pluggable";
    version = "5.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIMONW/Module-Pluggable-5.2.tar.gz";
      sha256 =
        "b3f2ad45e4fd10b3fb90d912d78d8b795ab295480db56dc64e86b9fa75c5a6df";
    };
    meta = {
      description =
        "Automatically give your module the ability to have plugins";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    pname = "Exporter-Tiny";
    version = "1.002002";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz";
      sha256 =
        "00f0b95716b18157132c6c118ded8ba31392563d19e490433e9a65382e707101";
    };
    meta = {
      homepage = "https://metacpan.org/release/Exporter-Tiny";
      description =
        "An exporter with the features of Sub::Exporter but only core dependencies";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathTinyGlob = buildPerlPackage {
    pname = "Path-Tiny-Glob";
    version = "0.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/Path-Tiny-Glob-0.2.0.tar.gz";
      sha256 =
        "f4caed0814efc4a6b481d6a1b57f9eccf2e49a25748c71eb4976785edd6e7265";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ ExporterTiny ListLazy Moo PathTiny ];
    meta = {
      homepage = "https://github.com/yanick/Path-Tiny-Glob";
      description = "File globbing utility";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListLazy = buildPerlPackage {
    pname = "List-Lazy";
    version = "0.3.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/List-Lazy-0.3.2.tar.gz";
      sha256 =
        "52b53709be0dfb7feae7edf212b8e1843bce72f02afd8dc74fb879305d982832";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs =
      [ Clone ExporterTiny ListMoreUtils Moo MooXHandlesVia ];
    meta = {
      homepage = "https://github.com/yanick/List-Lazy";
      description = "Generate lists lazily";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooXHandlesVia = buildPerlPackage {
    pname = "MooX-HandlesVia";
    version = "0.001009";
    src = fetchurl {
      url =
        "mirror://cpan/authors/id/T/TO/TOBYINK/MooX-HandlesVia-0.001009.tar.gz";
      sha256 =
        "716353e38894ecb7e8e4c17bc95483db5f59002b03541b54a72c27f2a8f36c12";
    };
    buildInputs = [ MooXTypesMooseLike TestException TestFatal ];
    propagatedBuildInputs =
      [ ClassMethodModifiers DataPerl ModuleRuntime Moo RoleTiny ];
    meta = {
      description = "NativeTrait-like behavior for Moo";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Importer = buildPerlPackage {
    pname = "Importer";
    version = "0.026";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EX/EXODIST/Importer-0.026.tar.gz";
      sha256 =
        "e08fa84e13cb998b7a897fc8ec9c3459fcc1716aff25cc343e36ef875891b0ef";
    };
    meta = {
      description =
        "Alternative but compatible interface to modules that export symbols";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

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

  strictures = buildPerlPackage {
    pname = "strictures";
    version = "2.000006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAARG/strictures-2.000006.tar.gz";
      sha256 =
        "09d57974a6d1b2380c802870fed471108f51170da81458e2751859f2714f8d57";
    };
    meta = {
      description = "Turn on strict and make most warnings fatal";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsDepends = buildPerlPackage {
    pname = "ExtUtils-Depends";
    version = "0.8001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.8001.tar.gz";
      sha256 =
        "673c4387e7896c1a216099c1fbb3faaa7763d7f5f95a1a56a60a2a2906c131c5";
    };
    meta = {
      homepage = "http://gtk2-perl.sourceforge.net";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFatal = buildPerlPackage {
    pname = "Test-Fatal";
    version = "0.016";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-Fatal-0.016.tar.gz";
      sha256 =
        "7283d430f2ba2030b8cd979ae3039d3f1b2ec3dde1a11ca6ae09f992a66f788f";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = "https://github.com/rjbs/Test-Fatal";
      description =
        "Incredibly simple helpers for testing code with exceptions";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Clone = buildPerlPackage {
    pname = "Clone";
    version = "0.45";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AT/ATOOMIC/Clone-0.45.tar.gz";
      sha256 =
        "cbb6ee348afa95432e4878893b46752549e70dc68fe6d9e430d1d2e99079a9e6";
    };
    buildInputs = [ BCOW ];
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeGuard = buildPerlPackage {
    pname = "Scope-Guard";
    version = "0.21";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.21.tar.gz";
      sha256 =
        "8c9b1bea5c56448e2c3fadc65d05be9e4690a3823a80f39d2f10fdd8f777d278";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

})
