{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    initrd = {
      systemd.enable = true;
      verbose = false;
      luks.devices."luks-1c272f8a-4d71-4963-ab97-f7b3242b7b9f".device =
        "/dev/disk/by-uuid/1c272f8a-4d71-4963-ab97-f7b3242b7b9f";
    };

    consoleLogLevel = 0;
    plymouth.enable = true;

    kernelParams = [
      "quiet"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
      "splash"
      "vt.global_cursor_default=0"
      "udev.log_priority=3"
    ];
  };

  systemd.services.display-manager.after = [ "plymouth-quit.service" ];

  services = {
    getty.helpLine = "";
    power-profiles-daemon.enable = true;
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "ignore";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        IdleAction=ignore
      '';
    };
  };
}
