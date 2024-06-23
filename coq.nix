{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      coq
      coqPackages.coq-lsp
      coqPackages.stdpp
      coqPackages.corn
      coqPackages.HoTT
    ];
  };
}
