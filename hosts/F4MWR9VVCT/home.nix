{ secretsPath, ... }:

let
  secrets = import secretsPath;
in
{
  home.username = secrets.workUsername;
  home.homeDirectory = "/Users/${secrets.workUsername}";

  imports = [
    ../../modules/aerospace.nix
    ../../modules/git.nix
    ../../modules/kitty.nix
    ../../modules/nvchad.nix
    ../../modules/packages.nix
    ../../modules/programs.nix
    ../../modules/sketchybar.nix
    ../../modules/skhd.nix
    ../../modules/stylix-home.nix
    ../../modules/tmux.nix
    ../../modules/zsh.nix
  ];

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;
  news.display = "silent";

  home.stateVersion = "25.05";
}
