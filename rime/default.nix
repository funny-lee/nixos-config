{
  lib,
  catppuccin-fcitx5,
  ...
}: {
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
  home.file.".local/share/fcitx5/themes".source = "${catppuccin-fcitx5}/src";
  home.file.".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
  home.file.".config/fcitx5/rime" = {
    source = ./rime-dict;
    recursive = true; # 递归整个文件夹
  };
}
