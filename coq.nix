{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      coqPackages.gaia
      coq
      coqPackages.coq-lsp
      coqPackages.stdpp
      coqPackages.corn
      coqPackages.HoTT
    ];
  };
}
