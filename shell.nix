{ nixpkgs ? import <nixpkgs> { }

, target    ? null
, component ? null

}:
########################################
let                                    # IMPORTS / UTILITIES

inherit (nixpkgs) pkgs;

cabal-new = (import ./haskell/project/cabal-new.nix) {
 inherit (pkgs) lib runCommand;
 inherit (pkgs) cabal-install;
};

in
########################################

cabal-new.runCabalNewBuild { inherit target component; }

########################################