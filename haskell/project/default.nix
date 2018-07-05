{ lib
, cabal-install
}:
########################################
let                                    # IMPORTS / UTILITIES

cabal-new = (import ./cabal-new.nix) {
 inherit lib cabal-install;
};

in
########################################
let                                    # "PUBLIC" EXPORTS / "PRIVATE" HELPERS



in
########################################
{                                      # THE EXPORTED "MODULE"



}
########################################
/* NOTES

====================

TODO generate this object automatically from `cabal.project`.

====================

`haskellProject.project` adds `all = ...;` to its given object.

====================

====================

*/
########################################