{ pkgs
# , pkgs-haskell-ormolu
, ... }:

{
  home.packages = with pkgs; [
    haskellPackages.haskell-language-server
    haskellPackages.stack
    haskellPackages.cabal-install
    haskellPackages.ghc
    haskellPackages.implicit-hie
    # haskellPackages.ghcup
  ] ++ [
    # pkgs-haskell-ormolu
    ];
}
