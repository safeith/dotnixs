{ config, pkgs, lib, ... }:

let
  sharedConfig = import ./stylix-shared.nix { inherit pkgs; };
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  stylix = {
    enable = true;
    base16Scheme = lib.mkIf isDarwin sharedConfig.base16Scheme;
    polarity = lib.mkIf isDarwin sharedConfig.polarity;
    fonts = lib.mkIf isDarwin sharedConfig.fonts;

    targets = {
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      kitty.enable = true;
      qt.enable = true;
      tmux.enable = true;
      vim.enable = true;
    };
  };
}
