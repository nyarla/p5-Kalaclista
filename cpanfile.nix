{ pkgs, ... }: with pkgs; with perlPackages; let modules = rec {
  BHooksOPCheck = buildPerlPackage {
    pname = "B-Hooks-OP-Check";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-OP-Check-0.22.tar.gz";
      sha256 = "c7b5d1bef59ef9087ff67eb3168d2624be94ae5464469e259ad11bfb8ad8cdcd";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      homepage = "https://github.com/karenetheridge/B-Hooks-OP-Check";
      description = "Wrap OP check callbacks";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  indirect = buildPerlPackage {
    pname = "indirect";
    version = "0.39";
    src = fetchurl {
      url = "mirror://cpan/authors/id/V/VP/VPIT/indirect-0.39.tar.gz";
      sha256 = "71733c4c348e98fdd575b44a52042428c39888a18c25656efe59ef3d7d0d27e5";
    };
    meta = {
      homepage = "http://search.cpan.org/dist/indirect/";
      description = "Lexically warn about using the indirect method call syntax";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  ClassAccessorLite = buildPerlPackage {
    pname = "Class-Accessor-Lite";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz";
      sha256 = "75b3b8ec8efe687677b63f0a10eef966e01f60735c56656ce75cbb44caba335a";
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
      url = "mirror://cpan/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.13.tar.gz";
      sha256 = "ab5807f71018a842de6b7a4826d6c1f24b8d5b09fcce5005a3309cf6ea40fd63";
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
      url = "mirror://cpan/authors/id/I/IL/ILMARI/multidimensional-0.014.tar.gz";
      sha256 = "12eb14317447bd15ab9799677db9eda20e784d8b113e44a5f6f11f529e862c5f";
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
      url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-0.29.tar.gz";
      sha256 = "1d3780aa9bea430afbe65aa8c76e718f1045ce788aadda4116f59d3b7a7ad2b4";
    };
    buildInputs = [ Moo TestFatal ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Some Moosish types and a type builder";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  HTMLSelectorXPath = buildPerlPackage {
    pname = "HTML-Selector-XPath";
    version = "0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.26.tar.gz";
      sha256 = "3df80a81284d1e375d9d1f6fec16e96c31b2c309451b4ba82e5fd1db23ac1f24";
    };
    buildInputs = [ TestBase ];
    meta = {
      description = "CSS Selector to XPath compiler";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  ListMoreUtilsXS = buildPerlPackage {
    pname = "List-MoreUtils-XS";
    version = "0.430";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz";
      sha256 = "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242";
    };
    meta = {
      homepage = "https://metacpan.org/release/List-MoreUtils-XS";
      description = "Provide the stuff missing in List::Util in XS";
      license = lib.licenses.asl20;
    };
  };
  ModuleBuildTiny = buildPerlModule {
    pname = "Module-Build-Tiny";
    version = "0.039";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz";
      sha256 = "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c";
    };
    propagatedBuildInputs = [ ExtUtilsConfig ExtUtilsHelpers ExtUtilsInstallPaths ];
    meta = {
      description = "A tiny replacement for Module::Build";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  barewordfilehandles = buildPerlPackage {
    pname = "bareword-filehandles";
    version = "0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/bareword-filehandles-0.007.tar.gz";
      sha256 = "4134533716d87af8fff56e250c488ad06df0a7bff48e7cf7de63ff6bc8d9c17f";
    };
    buildInputs = [ ExtUtilsDepends ];
    propagatedBuildInputs = [ BHooksOPCheck ];
    meta = {
      homepage = "https://github.com/ilmari/bareword-filehandles";
      description = "Disables bareword filehandles";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  PathTinyGlob = buildPerlPackage {
    pname = "Path-Tiny-Glob";
    version = "0.2.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/Path-Tiny-Glob-0.2.0.tar.gz";
      sha256 = "f4caed0814efc4a6b481d6a1b57f9eccf2e49a25748c71eb4976785edd6e7265";
    };
    buildInputs = [ Test2Suite ];
    propagatedBuildInputs = [ ExporterTiny ListLazy Moo PathTiny ];
    meta = {
      homepage = "https://github.com/yanick/Path-Tiny-Glob";
      description = "File globbing utility";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  XMLLibXMLjQuery = buildPerlModule {
    pname = "XML-LibXML-jQuery";
    version = "0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CA/CAFEGRATZ/XML-LibXML-jQuery-0.08.tar.gz";
      sha256 = "e6012793cd1a90101b3c4ba1ffed3f707fa6fbd9d92bde9390d2f5bf05411503";
    };
    
    prePatch = ''
      rm t/as_html.t
      rm t/replace_with.t
    '';

    buildInputs = [ ModuleBuildTiny TestException ];
    propagatedBuildInputs = [ HTMLSelectorXPath JSON XMLLibXML ];
    meta = {
      homepage = "https://github.com/cafe01/xml-libxml-jquery";
      description = "Fast, jQuery-like DOM manipulation over XML::LibXML";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  ListLazy = buildPerlPackage {
    pname = "List-Lazy";
    version = "0.3.2";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Y/YA/YANICK/List-Lazy-0.3.2.tar.gz";
      sha256 = "52b53709be0dfb7feae7edf212b8e1843bce72f02afd8dc74fb879305d982832";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ Clone ExporterTiny ListMoreUtils Moo MooXHandlesVia ];
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
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz";
      sha256 = "535430919e6fdf6ce55ff76e9892afccba3b7d4160db45f3ac43b0f92ffcd049";
    };
    meta = {
      homepage = "https://github.com/dagolden/Test-Number-Delta";
      description = "Compare the difference between numbers against a given tolerance";
      license = lib.licenses.asl20;
    };
  };
  ParallelForkBossWorkerAsync = buildPerlPackage {
    pname = "Parallel-Fork-BossWorkerAsync";
    version = "0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JVANNUCCI/Parallel-Fork-BossWorkerAsync-0.09.tar.gz";
      sha256 = "76481f21fac3663d357fa369e70cae43e47274d34cf0924d563a3c438c7989a4";
    };
    meta = {
      description = "Perl extension for creating asynchronous forking queue processing applications";
    };
  };
}; in with modules; [  AlgorithmDiff BCOW BHooksOPCheck CaptureTiny ClassAccessorLite ClassMethodModifiers Clone DataPerl ExporterTiny ExtUtilsConfig ExtUtilsDepends ExtUtilsHelpers ExtUtilsInstallPaths HTMLSelectorXPath Importer JSON ListLazy ListMoreUtils ListMoreUtilsXS ModuleBuild ModuleBuildTiny ModulePluggable ModuleRuntime Moo MooXHandlesVia MooXTypesMooseLike ParallelForkBossWorkerAsync PathTiny PathTinyGlob RoleTiny ScopeGuard Spiffy SubInfo SubQuote SubUplevel TermTable Test2Suite TestBase TestDeep TestException TestFatal TestLeakTrace TestNeeds TestNumberDelta TestOutput TestRequires TestWarn TextDiff TimeMoment TryTiny URI XMLLibXML XMLLibXMLjQuery YAMLTiny barewordfilehandles indirect multidimensional strictures ]
