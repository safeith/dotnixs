{ config, pkgs, lib, ... }:

let
  sharedConfig = import ./stylix-shared.nix { inherit pkgs; };
in
{
  stylix = {
    enable = true;
    autoEnable = true;

    inherit (sharedConfig) base16Scheme polarity image iconTheme cursor fonts;

    targets = {
      chromium.enable = false;
    };
  };
}
