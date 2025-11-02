{ config, pkgs, lib, ... }:

{
  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      nfmt = "nvim +':lua vim.lsp.buf.format()' +wq";
      rebuild-work =
        "sudo darwin-rebuild switch --flake ~/.config/nix#F4MWR9VVCT --impure";
      rebuild-personal =
        "sudo nixos-rebuild switch --flake ~/.config/nix#thinkFREE --impure";
      nix-clean = "nix-collect-garbage -d && nix store optimise && sudo nix-collect-garbage -d && sudo nix store optimise";
    };

    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.zsh";
      }

      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }

      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.plugin.zsh";
      }

      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];

    initContent = ''
      if [ -d ~/.zsh/plugins/ohmyzsh ]; then
        source ~/.zsh/plugins/ohmyzsh/plugins/sudo/sudo.plugin.zsh
        source ~/.zsh/plugins/ohmyzsh/plugins/aws/aws.plugin.zsh
        source ~/.zsh/plugins/ohmyzsh/plugins/gcloud/gcloud.plugin.zsh
        source ~/.zsh/plugins/ohmyzsh/plugins/kubectl/kubectl.plugin.zsh
        source ~/.zsh/plugins/ohmyzsh/plugins/podman/podman.plugin.zsh
        source ~/.zsh/plugins/ohmyzsh/plugins/command-not-found/command-not-found.plugin.zsh
      fi

      # Auto-start tmux if in Kitty and not already inside tmux
      if command -v tmux >/dev/null 2>&1; then
        if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ "$TERM" == "xterm-kitty" ]]; then
          tmux attach -t main || tmux new -s main
        fi
      fi

      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  home.file.".zsh/plugins/ohmyzsh".source = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "680298e920069b313650c1e1e413197c251c9cde";
    sha256 = "sha256-RcYm8MdR5r1V7eUE40TzOFHOBoVbY33rk79EFOLet2Y=";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.command-not-found.enable = true;

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      format = "$directory$character";
      right_format = "$git_branch$git_commit$git_state$git_metrics$git_status";

      gcloud = {
        format = "[](sapphire)  [$project](sapphire) ";
        disabled = false;
      };
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [ "--group-directories-first" "--icons" ];
    colors = "always";
    git = true;
    icons = "always";
  };
}
