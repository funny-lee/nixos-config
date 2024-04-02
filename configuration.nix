# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  environment.pathsToLink = ["/share/zsh"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # nixpkgs.config.allowBroken = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts = ''
        # Please Star : https://github.com/ineo6/hosts
        # GitHub Host End
    185.199.110.154              github.githubassets.com
    140.82.112.21                central.github.com
    185.199.111.133              desktop.githubusercontent.com
    185.199.109.153              assets-cdn.github.com
    185.199.108.133              camo.githubusercontent.com
    185.199.111.133              github.map.fastly.net
    151.101.1.194                github.global.ssl.fastly.net
    140.82.112.4                 gist.github.com
    185.199.111.153              github.io
    140.82.112.4                 github.com
    140.82.112.5                 api.github.com
    185.199.108.133              raw.githubusercontent.com
    185.199.109.133              user-images.githubusercontent.com
    185.199.109.133              favicons.githubusercontent.com
    185.199.108.133              avatars5.githubusercontent.com
    185.199.111.133              avatars4.githubusercontent.com
    185.199.109.133              avatars3.githubusercontent.com
    185.199.110.133              avatars2.githubusercontent.com
    185.199.110.133              avatars1.githubusercontent.com
    185.199.111.133              avatars0.githubusercontent.com
    185.199.108.133              avatars.githubusercontent.com
    140.82.112.9                 codeload.github.com
    52.217.74.225                github-cloud.s3.amazonaws.com
    54.231.163.153               github-com.s3.amazonaws.com
    52.217.70.116                github-production-release-asset-2e65be.s3.amazonaws.com
    16.182.71.177                github-production-user-asset-6210df.s3.amazonaws.com
    52.217.136.193               github-production-repository-file-5c1aeb.s3.amazonaws.com
    185.199.111.153              githubstatus.com
    140.82.114.17                github.community
    185.199.110.133              media.githubusercontent.com
    185.199.109.133              objects.githubusercontent.com
    185.199.110.133              raw.github.com
    20.221.80.166                copilot-proxy.githubusercontent.com
  '';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  fonts = {
    fontDir.enable = true;
    packages = with pkgs;
      [
        noto-fonts
        # noto-fonts-cjk-sans
        # noto-fonts-cjk-serif
        source-han-sans
        source-han-serif
        sarasa-gothic #更纱黑体
        source-code-pro
        hack-font
        jetbrains-mono
        fira-code
        intel-one-mono
        mononoki
        (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode"];})
      ]
      ++ [
        nodePackages_latest.pnpm
        nodePackages_latest.vercel
        nodePackages_latest.prisma
      ];
  };
  # Prisma:
  environment.variables.PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  environment.variables.PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  environment.variables.PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
  fonts.fontconfig = {
    defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = [
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Source Han Sans SC"
        "DejaVu Sans"
      ];
      serif = [
        "Noto Serif CJK SC"
        "Source Han Serif SC"
        "DejaVu Serif"
      ];
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];

    # 我现在用 ibus
    #  enabled = "ibus";
    #  ibus.engines = with pkgs.ibus-engines; [
    #    libpinyin
    #    rime
    #  ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store"];
  boot.loader.systemd-boot.configurationLimit = 7;
  # boot.loader.grub.configurationLimit = 10;
  services.postgresql = {
    enable = true;
    ensureDatabases = ["mydatabase"];
    enableTCPIP = true;
    # port = 5432;
    settings = {
      listen_addresses = "*";
    };
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      local all       all     trust
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement = {
      enable = true;

      # note: this option doesn't currently do the right thing when you have a pre-Ampere card.
      # if you do, add "nvidia.NVreg_DynamicPowerManagement=0x02" to your kernelParams.
      # for Ampere and newer cards, this option is on by default.
      finegrained = true;
    };
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    nvidiaPersistenced = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

    prime = {
      offload.enable = true;
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.uinput.enable = true;
  users.groups.input.members = ["fll"];
  users.groups.uinput.members = ["fll"];
  users.users."fll".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRzAXnLdt96xG3RRJiGDUu+YNFRR3BhsHzuyOfhp1DvYy547k8YQwX/kJWuSwL6LNt5boLkC24BIfo9btu9ZN7Nxnf7w7Lh3kORLQ+Co/OTvblVORWpN1boA3Q12nirRJpxjC6gxKrd63L3Nl5BHhmex92jHahNPyVs+UQu+FF0uKsIxd//UpvHjhR+HlmGRBNZ7bN3xutwfkYAsKjllObX2IhyaC/28XFtb/Uzs5+ZPvWFsUgOtY45uDtD5AcEL8A5tCnoDWIZBaV1lWBt7uLCVIOx6qbWGOgHuflyxwR5Ku92rvZjrlJKK/oNZ8zEhoQE4mbRueA0T+p/liQvmwrheBprDWJhfO7hNKMsbIaas/MKorVCkhPmRzXGVmuVG8RDtSUwyVrk3sMhoqWZAAmWqVwFfapd5DHrk0Xgm0C8xRsvSX6+0RKGT51fuXq6QmrMen6NyTbgiYg+Cu7GvhmDsuFCdr1g+yxGgwtHBbtb7mJDkvCUtu8h8WOkPwvpzrwS5ihg87CdDo7r0dvlf3HKbgjwXleihUltuAc2QdOwpK79kXMUim4SVOJ3PXj3zujRgtDXMRLhFk7e2Hb+sBYx10vL1LviVckmCJF3UGIY0pPZXxGohcXo/SNSDoMDQSltIrY6dXs7wcbNSFjLjjKKt7PPyy0Yjs2Ip9nRUk3Fw== 1750285541@qq.com" # content of authorized_keys file
    # note: ssh-copy-id will add user@your-machine after the public key
    # but we can remove the "@your-machine" part
  ];
  hardware.opengl.driSupport32Bit = true;
  virtualisation.docker.enable = true;
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.docker.enableNvidia = true;
  systemd.enableUnifiedCgroupHierarchy = false;
  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "cn";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fll = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "fll";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      # firefox
      gmp4
      czmq
      kate
      wget
      clash-meta
      alacritty
      zsh
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  boot.supportedFilesystems = ["ntfs"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    abella
  ];
  # compile
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  systemd.services.nix-daemon.environment = {
    http_proxy = "127.0.0.1:7890";
    https_proxy = "127.0.0.1:7890";
  };
  # Set environment variables
  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    # GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
    # GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
    MOZ_ENABLE_WAYLAND = "1";
    # ZK_NOTEBOOK_DIR = "$HOME/stuff/notes/";
    EDITOR = "nvim";
    # DIRENV_LOG_FORMAT = "";
    # ANKI_WAYLAND = "1";
    # DISABLE_QT5_COMPAT = "0";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nix.settings.trusted-users = ["fll"];
}
