{ pkgs, config, lib, ... }:

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
    ../../modules/stylix-home.nix
    ../../modules/tmux.nix
    ../../modules/waybar.nix
    ../../modules/zsh.nix
  ];

  # X resources configuration (DPI and font rendering)
  xresources.properties = {
    "Xft.dpi" = 120;
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = "hintslight";
    "Xft.rgba" = "rgb";
    "Xft.lcdfilter" = "lcddefault";
  };

  # GTK icon theme configuration (Stylix doesn't auto-configure this)
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Qt icon theme configuration
  xdg.configFile."qt5ct/qt5ct.conf".text = lib.mkAfter ''
    [Icons]
    Theme=Papirus-Dark
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = lib.mkAfter ''
    [Icons]
    Theme=Papirus-Dark
  '';

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
