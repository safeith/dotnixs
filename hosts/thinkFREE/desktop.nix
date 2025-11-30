{ config, pkgs, ... }:

{
  programs.hyprland = { enable = true; };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = { default = [ "hyprland" "gtk" ]; };
      hyprland = { default = [ "hyprland" "gtk" ]; };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd 'Hyprland >/dev/null 2>&1'";
        user = "greeter";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    mint-cursor-themes
    papirus-icon-theme
    seahorse
  ];

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu
      vazir-fonts
    ];

    fontconfig.defaultFonts = {
      serif = [ "Ubuntu Nerd Font" "Vazirmatn" ];
      sansSerif = [ "Ubuntu Nerd Font" "Vazirmatn" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
