# System-wide theming configuration using Stylix
# Provides consistent theming across all applications and desktop environments
# Base16 scheme: Catppuccin Mocha (dark theme)
{ config, pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    image = ./../wallpapers/lofi.jpg;

    targets = { chromium.enable = false; };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.mint-cursor-themes;
    };

    fonts = {
      sizes = {
        applications = 11;
        desktop = 11;
      };

      serif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu;
        name = "Ubuntu Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
