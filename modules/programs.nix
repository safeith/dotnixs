{ pkgs, lib, ... }:

let isPersonal = pkgs.stdenv.isLinux;

in {
  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      paging = "never";
    };
  };

  programs.chromium = lib.mkIf isPersonal {
    enable = true;
    package = pkgs.brave.override {
      commandLineArgs =
        [ "--disable-pinch" "--password-store=gnome-libsecret" ];
    };
  };

  programs.btop.enable = true;
  programs.command-not-found.enable = true;

  services.podman.enable = lib.mkIf
    isPersonal
    true;
  services.easyeffects.enable = lib.mkIf
    isPersonal
    true;
}

