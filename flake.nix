{
  description = "NixOS configuration";
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
    }: let
    constants = import ./constants.nix;

    # `lib.genAttrs [ "foo" "bar" ] (name: "x_" + name)` => `{ foo = "x_foo"; bar = "x_bar"; }`
    forEachSystem = func: (nixpkgs.lib.genAttrs constants.allSystems func);

    allSystemConfigurations = import ./systems {inherit self inputs constants;};
  in
    allSystemConfigurations
    // {

     formatter = forEachSystem (
        system: nixpkgs.legacyPackages.${system}.alejandra
      );

    devShells = forEachSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
              bashInteractive
              # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
              gcc
            ];
            name = "dots";
            shellHook = ''
              ${self.checks.${system}.pre-commit-check.shellHook}
            '';
          };
        }
      );
    };

    nixosConfigurations = {
      # 这里的 nixos-test 替换成你的主机名称
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
	  ./hardware-configuration.nix
          ./hyprland.nix

	  {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituters` in `flake.nix`
            nix.settings.trusted-users = [ "fll" ];
          }
          # 将 home-manager 配置为 nixos 的一个 module
          # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # 这里的 ryan 也得替换成你的用户名
            # 这里的 import 函数在前面 Nix 语法中介绍过了，不再赘述
            home-manager.users.fll = import ./home.nix;

            # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
            # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
            home-manager.extraSpecialArgs =  inputs;
          }
        ];
      };
    };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nvimdots.url = "github:ayamir/nvimdots";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # modern window compositor
    hyprland = {
    url = "github:hyprwm/Hyprland/v0.33.1";
    inputs.nixpkgs.follows = "nixpkgs";
    };
    # community wayland nixpkgs
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    xremap-flake.url = "github:xremap/nix-flake";
    # anyrun - a wayland launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # astronvim = {
    #   url = "github:AstroNvim/AstroNvim/v3.36.0";
    #   flake = false;
    # };
    #
    nur-ryan4yin = {
      url = "github:ryan4yin/nur-packages";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:funny-lee/mywallpapers/main";
      flake = false;
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-cava = {
      url = "github:catppuccin/cava";
      flake = false;
    };

    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };
    catppuccin-fcitx5 = {
      url = "github:catppuccin/fcitx5";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };
  };

}
