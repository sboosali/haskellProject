{ nixpkgsFile ? <nixpkgs> 
, nixpkgsWith ? import nixpkgsFile
, nixpkgs     ? nixpkgsWith {}             # a.k.a. `import <nixpkgs> {}` 

, pkgs             ? nixpkgs.pkgs
, haskellUtilities ? pkgs.haskell.lib 
}@arguments:

########################################

/*NOTES

nix-repl> import ./project.nix {}
{ asBuildDepends = «lambda»; asBuildInputs = «lambda»; getBuildDepends = «lambda»; getBuildInputs = «lambda»; }

*/

########################################

########################################

let

# mkDerivation = haskellUtilities.mkDerivation;

inherit (pkgs.lib)
 concat
 # mapAttrs
 # mapAttrsToList
 # escapeShellArg
 # optionalString
 # concatStringsSep
 # concatMapStringsSep
 ;

in 
########################################
let

getBuildDepends = p:
  let 
  q = asBuildDepends p;
  in
  q.out
  ;

asBuildDepends = p:
  let
  q = p.override
        { mkDerivation = mkDerivationDependencies;
        };
  in
  q
  ;

/*

:: HaskellPackage?
-> HaskellDerivation
-> Derivation?


*/
mkDerivationDependencies = d: 
  let
  buildDepends             = d.buildDepends             or [];
  libraryHaskellDepends    = d.libraryHaskellDepends    or [];
  executableHaskellDepends = d.executableHaskellDepends or [];
  
  allDepends = concat [
      buildDepends
      libraryHaskellDepends
      executableHaskellDepends
  ];
  in

  { out = allDepends; 
  };

 # (reflex.override
 #   { mkDerivation = drv:
 #     { out = (drv.buildDepends or [])
 #          ++ (drv.libraryHaskellDepends or []) 
 #          ++ (drv.executableHaskellDepends or []);
 #     };
 #   }).out)

####################

getBuildInputs = p:
  let 
  q = asBuildInputs p;
  in
  q.out
  ;

asBuildInputs = p:
  let
  q = p.override
        { mkDerivation = mkDerivationBuildInputs p;
        };
  in
  q
  ;

/*

:: HaskellPackage?
-> HaskellDerivation
-> Derivation?

*/
mkDerivationBuildInputs = p: d: 
  let
  inherit (p) compiler;

  extractedBuildInputs =
      haskellUtilities.extractBuildInputs compiler d;

  # { haskellBuildInputs
  # , systemBuildInputs
  # , propagatedBuildInputs
  # , otherBuildInputs
  # } = haskellUtilities.extractBuildInputs compiler d;

  buildInputs = with extractedBuildInputs;
    concat [ 
      haskellBuildInputs
      systemBuildInputs
      propagatedBuildInputs
      otherBuildInputs
    ];
  
  in

  { out = buildInputs; 
  };

in
########################################
let

dependencyDerivation = x:
 let

 y = x.override
   { mkDerivation = drv:
     { out = (drv.buildDepends             or [])
          ++ (drv.libraryHaskellDepends    or []) 
          ++ (drv.executableHaskellDepends or []);
     };
   };

 in

 y.out;

in 
########################################
let

exports = { inherit
 getBuildDepends
 getBuildInputs
 asBuildDepends
 asBuildInputs
;};

in 
########################################

exports

########################################
/* NOTES

====================

[dependencyDerivation]

replace a derivation with its dependencies. 
(by overriding the `out` attribute, a special "output-attribute").

====================

*/
########################################