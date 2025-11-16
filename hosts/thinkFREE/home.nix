{ pkgs, config, ... }:

{
  home.username = config.userConfig.personalUsername;
  home.homeDirectory = "/home/${config.userConfig.personalUsername}";

  imports = [
    ../../modules/acli.nix
    ../../modules/git.nix
    ../../modules/hyprland.nix
    ../../modules/hyprland-extras.nix
    ../../modules/kitty.nix
    ../../modules/nvchad.nix
    ../../modules/packages.nix
    ../../modules/programs.nix
    ../../modules/rofi.nix
    ../../modules/tmux.nix
    ../../modules/waybar.nix
    ../../modules/zsh.nix
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    GIT_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
  };

  home.stateVersion = "25.05";
}
