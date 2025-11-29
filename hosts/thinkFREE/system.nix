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

    kernelParams = [
      "quiet"
      "loglevel=0"
      "systemd.show_status=false"
      "console=current"
    ];
  };

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
