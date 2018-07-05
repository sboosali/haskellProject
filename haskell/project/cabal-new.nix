{ lib
, runCommand
, cabal-install
}:
########################################
let                                    # IMPORTS / UTILITIES

hasUnionType = expectedTypes: value:
  let
  actualType = builtins.typeOf value;
  in
  lib.lists.elem actualType expectedTypes;

hasType_MaybeString =
 hasUnionType ["string" "null"];

in
########################################
let                                    # "PUBLIC" EXPORTS / "PRIVATE" HELPERS

runCabalNewBuild =

 { target    ? null                    # e.g. `all`, `my-backend`, `my-frontend`, ...
 , component ? null                    # e.g. `lib`, `exe`, `test`, `bench`, ...
 , ...
 }:

 let
 
 argument = 

  if      (target == null) && (component == null)
  then    "all"

  else if (target != null) && (component != null)
  then    ''${target}:${component}''

  else if (target != null) && (component == null)
  then    target

  else if (target == null) && (component != null)
  then    component

  else    builtins.throw ''[ runCabalNewBuild { target=${target}; component=${component}; } ]: the TARGET and COMPONENT must have type `Maybe String` (i.e. `null` or `"..."`).'';

 in

 assert (hasType_MaybeString target);
 assert (hasType_MaybeString component);

 runCommand "cabal-new-build" {
  CABAL = cabal-install;
 } ''

 "$CABAL/bin/cabal" new-build ${argument}

 '';

in
########################################
{                                      # THE EXPORTED "MODULE"

 inherit runCabalNewBuild;



}
########################################
/* NOTES

====================

 
 typesOf = {
  target    = { expected = ["string","null"]; actual = builtins.typeOf target;
  component = builtins.typeOf component;
 };


====================

  nix-repl> cabal-install
  «derivation /nix/store/i3dkcabbs7q3n21nr84c4v0a7x2x5qj8-cabal-install-2.2.0.0.drv» 
  
  nix-repl> cabal-install.outputs
  [ "out" ]
  
  nix-repl> cabal-install.out
  «derivation /nix/store/i3dkcabbs7q3n21nr84c4v0a7x2x5qj8-cabal-install-2.2.0.0.drv»
  
  nix-repl> cabal-install.outPath
  "/nix/store/mzp1s0d0169fpclzg7rrpx9ic44f9xy6-cabal-install-2.2.0.0"
  
  nix-repl> :b cabal-install
  this derivation produced the following outputs:
    out -> /nix/store/mzp1s0d0169fpclzg7rrpx9ic44f9xy6-cabal-install-2.2.0.0
  
  $ find /nix/store/mzp1s0d0169fpclzg7rrpx9ic44f9xy6-cabal-install-2.2.0.0
  _/
  _/etc
  _/etc/bash_completion.d
  _/etc/bash_completion.d/cabal
  _/bin
  _/bin/cabal
  _/share
  _/share/man
  _/share/man/man1
  _/share/man/man1/cabal.1.gz

====================

ERROR

  building '/nix/store/pqllq0ngwll21i9gbnfry35dbkqb3ws5-cabal-new-build.drv'...
  Config file path source is default config file.
  Config file /homeless-shelter/.cabal/config not found.
  Writing default configuration to /homeless-shelter/.cabal/config
  /homeless-shelter: createDirectory: permission denied (Permission denied)
  builder for '/nix/store/pqllq0ngwll21i9gbnfry35dbkqb3ws5-cabal-new-build.drv' failed with exit code 1

====================

====================

*/
########################################