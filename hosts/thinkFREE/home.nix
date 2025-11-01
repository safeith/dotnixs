{ pkgs, ... }:

{
  home.username = "safeith";
  home.homeDirectory = "/home/safeith";

  imports = [
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
    ../../modules/webapps.nix
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

  xdg.desktopEntries."1password" = {
    name = "1Password";
    exec =
      "1password --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    icon = "1password";
    type = "Application";
    terminal = false;
    categories = [ "Office" ];
    mimeType = [ "x-scheme-handler/onepassword" ];
    settings = { StartupWMClass = "1Password"; };
  };

  home.stateVersion = "25.05";
}
