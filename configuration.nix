# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts = ''
  # GitHub Host Start
  185.199.111.154              github.githubassets.com
  140.82.114.21                central.github.com
  185.199.110.133              desktop.githubusercontent.com
  185.199.110.153              assets-cdn.github.com
  185.199.110.133              camo.githubusercontent.com
  185.199.108.133              github.map.fastly.net
  151.101.129.194              github.global.ssl.fastly.net
  140.82.113.4                 gist.github.com
  185.199.111.153              github.io
  140.82.113.3                 github.com
  140.82.114.5                 api.github.com
  185.199.111.133              raw.githubusercontent.com
  185.199.110.133              user-images.githubusercontent.com
  185.199.109.133              favicons.githubusercontent.com
  185.199.110.133              avatars5.githubusercontent.com
  185.199.111.133              avatars4.githubusercontent.com
  185.199.108.133              avatars3.githubusercontent.com
  185.199.110.133              avatars2.githubusercontent.com
  185.199.111.133              avatars1.githubusercontent.com
  185.199.108.133              avatars0.githubusercontent.com
  185.199.111.133              avatars.githubusercontent.com
  140.82.112.10                codeload.github.com
  52.217.233.209               github-cloud.s3.amazonaws.com
  52.217.75.132                github-com.s3.amazonaws.com
  52.217.134.161               github-production-release-asset-2e65be.s3.amazonaws.com
  52.217.66.156                github-production-user-asset-6210df.s3.amazonaws.com
  52.217.235.49                github-production-repository-file-5c1aeb.s3.amazonaws.com
  185.199.109.153              githubstatus.com
  140.82.112.18                github.community
  185.199.108.133              media.githubusercontent.com
  185.199.108.133              objects.githubusercontent.com
  185.199.109.133              raw.github.com
  20.221.80.166                copilot-proxy.githubusercontent.com
  
  # Please Star : https://github.com/ineo6/hosts
  # Mirror Repo : https://gitlab.com/ineo6/hosts
  
  # Update at: 2023-08-06 16:11:33
  
  # GitHub Host End
'';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
    fonts = with pkgs; [
      noto-fonts
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };

   # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
    fonts.fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
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
  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  boot.loader.systemd-boot.configurationLimit = 7;
  # boot.loader.grub.configurationLimit = 10;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "cn";
    xkbVariant = "";
  };
  services.xserver.windowManager.xmonad = {
   enable = true;
   enableContribAndExtras = true;
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fll = {
    isNormalUser = true;
    description = "fll";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      git
      wget
      clash
      alacritty
      zsh
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];
  # conpile
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
 # systemd.services.nix-daemon.environment = {
 #    http_proxy = "http://127.0.0.1:7890";
 #    https_proxy = "http://127.0.0.1:7890";
 #  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.trusted-users = [ "fll" ];
}
