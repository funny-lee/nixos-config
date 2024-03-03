{nixpkgs, ...}: {
imports = [
./anyrun.nix
./default.nix
./hyprland.nix
./packages.nix
./wayland-apps.nix
];
}
