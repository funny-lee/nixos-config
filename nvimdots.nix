{pkgs, ...}:
{
  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;
    withBuildTools = true;
    withHaskell = true; # If you want to use Haskell.
    extraHaskellPackages = hsPkgs: []; # Configure packages for Haskell (nixpkgs.haskellPackages).
    extraDependentPackages = with pkgs; [] # Properly setup the directory hierarchy (`lib`, `include`, and `pkgconfig`).
  }
}