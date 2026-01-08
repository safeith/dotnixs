{ pkgs, pkgs-unstable, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./desktop.nix
    ./hardware.nix
    ./network.nix
    ../../modules/stylix-system.nix
    ../../modules/system-optimization.nix
  ];

  networking.hostName = "thinkFREE";

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${config.userConfig.personalUsername} = {
    isNormalUser = true;
    description = config.userConfig.Name;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [{
    users = [ config.userConfig.personalUsername ];
    commands = [{
      command = "/run/current-system/sw/bin/nixos-rebuild";
      options = [ "NOPASSWD" ];
    }];
  }];

  environment = {
    variables.EDITOR = "nvim";
    variables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; [
      pciutils
      tpm2-tss
      usbutils
      lm_sensors
      exfatprogs
      ntfs3g
      wireguard-tools
    ];
  };

  programs = {
    zsh.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
