{ config, pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    image = ./../wallpapers/lofi.jpg;

    targets = {
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      kitty.enable = true;
      tmux.enable = true;
      vim.enable = true;
    };

    fonts = {
      sizes = {
        applications =
          if pkgs.stdenv.isDarwin then 13 else 11; # isWork vs isPersonal
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
