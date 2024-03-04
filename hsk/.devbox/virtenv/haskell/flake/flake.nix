{
  description = "A flake that outputs haskell with custom packages. Used by the devbox haskell plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
  };

  outputs = { self, nixpkgs }:
    let
      version = builtins.elemAt (builtins.match "^haskell\.compiler\.(.*)$" "haskell") 0;
      
      ghcWithPackages = if "haskell" == "ghc" 
        then nixpkgs.legacyPackages.x86_64-linux.pkgs.haskellPackages.ghcWithPackages
        else nixpkgs.legacyPackages.x86_64-linux.pkgs.haskell.packages.${version}.ghcWithPackages;

      haskellPackages = builtins.concatLists(builtins.filter (x: x != null) [
        # Test if haskell is a haskell package
        (builtins.match "^(stack|cabal-install)$" "haskell")
        (builtins.match "^haskellPackages\.(.*)$" "haskell")
        (builtins.match "^haskell\.packages\.[^.]*\.(.*)$" "haskell")
      ]);
    in
    {
      packages.x86_64-linux = {
        default = ghcWithPackages (ps: with ps;
          map (haskellPackage: ps.${haskellPackage}) haskellPackages
        );
      };
    };
}
