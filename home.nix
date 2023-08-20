{ config, pkgs, lib , stdenv , ... }:
{
  imports = [
  ./clash.nix
  ./singleton_web_apps.nix
  ];

  # 注意修改这里的用户名与用户目录
  home.username = "fll";
  home.homeDirectory = "/home/fll";
    # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 14;
    "Xft.dpi" = 112;
  };

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "funny-lee";
    userEmail = "1750285541@qq.com";
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
    neofetch
    joshuto # terminal file manager
    zoxide
   # neovim
    neovide
    tmux
    # archives
    zip
    xz
    unzip
    p7zip
    bat
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    exa # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd
    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    clash-verge
    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    gnumake
    makefile2graph
    remake
    pandoc
    nix-tree
    flamegraph
    universal-ctags
    graphviz
    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    zathura
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    texlab
    mpv
  ];

  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - 一个跨平台终端，带 GPU 加速功能
  programs.alacritty = {
    enable = true;
    # 自定义配置
    settings = {
      env.TERM = "xterm-256color";
    #  import = [ /home/fll/.config/alacritty/alacritty.yml ];
      font = { size = 14.0; };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [ "new-session" "-t" "main" ];
      };
    };
  };
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
     
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      eval "$(zoxide init bash)"
    '';

    # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
      gc = "git clone";
      nvd = "neovide";
      k = "kubectl";
      exa = "exa -all";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      jo = "joshuto";
    };
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
 
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  systemd.user.services.clash = {
      Unit = {
        Description = "Auto start clash";
        After = ["network.target"];
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${pkgs.clash.outPath}/bin/clash -d ${home.homeDirectory}/Gist/clash";
      };
    };
    config.proxyPort = 7890;
    programs.bash.bashrcExtra = ''
      # proxy
      ## default
      HTTP_PROXY="http://127.0.0.1:${toString config.proxyPort}/"
      ## microsoft wsl
      if [[ $(uname -r) == *"microsoft"* ]]; then
          hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
          export HTTP_PROXY="http://$hostip:${toString config.proxyPort}"
      fi
      export HTTPS_PROXY="$HTTP_PROXY"
      export HTTP_PROXY="$HTTP_PROXY"
      export FTP_PROXY="$HTTP_PROXY"
      export http_proxy="$HTTP_PROXY"
      export https_proxy="$HTTP_PROXY"
      export ftp_proxy="$HTTP_PROXY"
    '';
}
