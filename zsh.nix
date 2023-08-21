{ pkgs, lib, config, ... }:
with lib;
in {

    	home.packages = [
	    pkgs.zsh
	];

        programs.zsh = {
            enable = true;

            # directory to put config files in
            dotDir = ".config/zsh";

            enableCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;

            # .zshrc
            initExtra = ''
                export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
                export ZK_NOTEBOOK_DIR="~/stuff/notes";
                bindkey '^ ' autosuggest-accept
                edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
                ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
                export FZF_TMUX_HEIGHT='60%'
                export fzf_preview_cmd='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'
                fzf-history-widget-accept() {
                fzf-history-widget
                zle accept-line
                }
                zle     -N     fzf-history-widget-accept
                bindkey '^X^R' fzf-history-widget-accept
            '';

            # basically aliases for directories: 
            # `cd ~dots` will cd into ~/.config/nixos
            dirHashes = {
                dots = "$HOME/.config/nixos";
                stuff = "$HOME/stuff";
                media = "/run/media/$USER";
                junk = "$HOME/stuff/other";
            };

            # Tweak settings for history
            history = {
                save = 1000;
                size = 1000;
                path = "$HOME/.cache/zsh_history";
            };

            # Set some aliases
            shellAliases = {
                c = "clear";
                mkdir = "mkdir -vp";
                rm = "rm -rifv";
                mv = "mv -iv";
                cp = "cp -riv";
                cat = "bat --paging=never --style=plain";
                erd = "erd -Hi";
                ls = "exa -a --icons";
                tree = "exa --tree --icons";
                nd = "nix develop -c $SHELL";
                update = "sudo nixos-rebuild switch";
                rebuild = "doas nixos-rebuild switch --flake $NIXOS_CONFIG_DIR --fast; notify-send 'Rebuild complete\!'";
            };

            # Source all plugins, nix-style
            oh-my-zsh = {
              enable = true;
              plugins = [ "git" "thefuck" "sudo"];
              theme = "dst";
        };
    };

}
