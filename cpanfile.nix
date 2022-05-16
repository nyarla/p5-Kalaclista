{ pkgs, ... }:
with pkgs;
with perlPackages;
let
  modules = rec {
    BHooksOPCheck = buildPerlPackage {
      pname = "B-Hooks-OP-Check";
      version = "0.22";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz";
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
    CommonMark = buildPerlPackage {
      pname = "CommonMark";
      version = "0.290000";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/N/NW/NWELLNHOF/CommonMark-0.290000.tar.gz";
        sha256 =
          "a501b4c3ef6ca89f8703f9ed0b2dc0da878281f2b1277a7ec92902e088c2eadd";
      };
      buildInputs = [ pkgs.cmark DevelChecklib ];

      PERL_MM_OPT =
        ''INC="-I${pkgs.cmark}/include" LIBS="-L${pkgs.cmark}/lib -lcmark"'';

      meta = {
        description = "Interface to the CommonMark C library";
        license = with lib.licenses; [ artistic1 gpl1Plus ];
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
    Carp = buildPerlPackage {
      pname = "Carp";
      version = "1.50";
      src = fetchurl {
        url = "mirror://cpan/authors/id/X/XS/XSAWYERX/Carp-1.50.tar.gz";
        sha256 =
          "f5273b4e1a6d51b22996c48cb3a3cbc72fd456c4038f5c20b127e2d4bcbcebd9";
      };
      meta = {
        description = "Alternative warn and die for modules";
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
    ModuleBuildPluggablePPPort = buildPerlModule {
      pname = "Module-Build-Pluggable-PPPort";
      version = "0.04";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/T/TO/TOKUHIROM/Module-Build-Pluggable-PPPort-0.04.tar.gz";
        sha256 =
          "44084ba3d8815f343bd391585ac5d8339a4807ce5c0dd84c98db8f310b64c0ea";
      };
      buildInputs = [ TestRequires ];
      propagatedBuildInputs = [ ClassAccessorLite ModuleBuildPluggable ];
      meta = {
        description = "Generate ppport.h";
        license = with lib.licenses; [ artistic1 gpl1Plus ];
      };
    };
    PathTinyGlob = buildPerlPackage {
      pname = "Path-Tiny-Glob";
      version = "0.2.0";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/Y/YA/YANICK/Path-Tiny-Glob-0.2.0.tar.gz";
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
    TestNumberDelta = buildPerlPackage {
      pname = "Test-Number-Delta";
      version = "1.06";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz";
        sha256 =
          "535430919e6fdf6ce55ff76e9892afccba3b7d4160db45f3ac43b0f92ffcd049";
      };
      meta = {
        homepage = "https://github.com/dagolden/Test-Number-Delta";
        description =
          "Compare the difference between numbers against a given tolerance";
        license = lib.licenses.asl20;
      };
    };
    HTML5DOM = buildPerlPackage {
      pname = "HTML5-DOM";
      version = "1.25";
      src = fetchurl {
        url = "mirror://cpan/authors/id/Z/ZH/ZHUMARIN/HTML5-DOM-1.25.tar.gz";
        sha256 =
          "a815c4bd6bada87203628f8e658d78610fdf9bd6b9dacfd10c437819416cee54";
      };
      meta = {
        description =
          "Super fast html5 DOM library with css selectors (based on Modest/MyHTML)";
        license = lib.licenses.mit;
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
    ModuleBuildPluggable = buildPerlModule {
      pname = "Module-Build-Pluggable";
      version = "0.10";
      src = fetchurl {
        url =
          "mirror://cpan/authors/id/T/TO/TOKUHIROM/Module-Build-Pluggable-0.10.tar.gz";
        sha256 =
          "e5bb2acb117792c984628812acb0fec376cb970caee8ede57535e04d762b0e40";
      };
      propagatedBuildInputs =
        [ ClassAccessorLite ClassMethodModifiers DataOptList TestSharedFork ];
      meta = {
        homepage = "https://github.com/tokuhirom/Module-Build-Pluggable";
        description = "Module::Build meets plugins";
        license = with lib.licenses; [ artistic1 gpl1Plus ];
      };
    };
  };
in with modules; [
  BCOW
  BHooksOPCheck
  CaptureTiny
  Carp
  ClassAccessorLite
  ClassMethodModifiers
  Clone
  CommonMark
  DataOptList
  DataPerl
  Encode
  EncodeDetect
  ExporterTiny
  ExtUtilsDepends
  FileWhich
  Filepushd
  HTML5DOM
  HTMLEscape
  HTTPTinyish
  IPCRun3
  ImageScale
  Importer
  ListLazy
  ListMoreUtils
  ListMoreUtilsXS
  MockConfig
  ModuleBuild
  ModuleBuildPluggable
  ModuleBuildPluggablePPPort
  ModuleCPANfile
  ModulePluggable
  ModuleRuntime
  Moo
  MooXHandlesVia
  MooXTypesMooseLike
  ParallelForkBossWorkerAsync
  ParamsUtil
  PathTiny
  PathTinyGlob
  RoleTiny
  ScopeGuard
  SubInfo
  SubInstall
  SubQuote
  SubUplevel
  TermTable
  Test2Suite
  TestDeep
  TestException
  TestFatal
  TestLeakTrace
  TestNeeds
  TestNumberDelta
  TestOutput
  TestRequires
  TestSharedFork
  TestWarn
  TimeMoment
  TryTiny
  URI
  XMLLibXML
  YAMLTiny
  barewordfilehandles
  indirect
  multidimensional
  strictures
]
