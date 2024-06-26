{
  pkgs,
  catppuccin-cava,
  nur-ryan4yin,
  ...
}:
# media - control and enjoy audio/video
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    imv # simple image viewer

    nvtopPackages.full

    # video/audio tools
    cava # for visualizing audio
    libva-utils
    vdpauinfo
    vulkan-tools
    glxinfo

    # terminal file manager
  ];

  # https://github.com/catppuccin/cava
  home.file.".config/cava/config".text =
    ''
      # custom cava config
    ''
    + builtins.readFile "${catppuccin-cava}/themes/mocha.cava";

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };

  services = {
    playerctld.enable = true;
  };
}
