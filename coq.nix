{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      coqPackages.coq
      coqPackages.coq-lsp
    ];
  };
}
