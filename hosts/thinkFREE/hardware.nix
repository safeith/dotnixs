{ pkgs, ... }:

let
  hwmonSensor = name: indices: {
    type = "hwmon";
    query = "/sys/class/hwmon";
    inherit name indices;
  };
in {
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    thinkfan = {
      enable = true;
      sensors = [
        (hwmonSensor "thinkpad" [ 3 4 ])
        (hwmonSensor "coretemp" [ 1 2 3 4 5 ])
        (hwmonSensor "nvme" [ 1 ])
        (hwmonSensor "pch_cannonlake" [ 1 ])
        (hwmonSensor "acpitz" [ 1 ])
        (hwmonSensor "iwlwifi_1" [ 1 ])
      ];

      levels = [
        [ 0 0 40 ]
        [ 1 40 60 ]
        [ "level auto" 60 80 ]
        [ "level disengaged" 80 255 ]
      ];
    };

    blueman.enable = true;

    udev = {
      packages = [ pkgs.android-udev-rules ];
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666"
      '';
    };

    logind.extraConfig = ''
      HandleLidSwitch=suspend-then-hibernate
      HandleLidSwitchDocked=ignore
    '';
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };

  security = {
    rtkit.enable = true;
    pam.services.hyprlock.text = "auth include login";
  };

  environment.etc."systemd/sleep.conf.d/override.conf".text = ''
    [Sleep]
    HibernateDelaySec=30min
  '';
}
