{ pkgs }:

{
  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  polarity = "dark";

  image = ./../wallpapers/lofi.jpg;

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
      applications = if pkgs.stdenv.isDarwin then 12 else 11;
      desktop = if pkgs.stdenv.isDarwin then 12 else 11;
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
}
