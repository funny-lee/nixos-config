{
  inputs,
  ...
}: {
  imports = [inputs.scientific-fhs.nixosModules.default];

  programs.scientific-fhs = {
    enable = true;
    juliaVersions = [
      {
        version = "julia_18";
        default = true;
      }
    ];
    enableNVIDIA =true;
  };
}
