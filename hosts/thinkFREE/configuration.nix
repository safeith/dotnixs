{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./desktop.nix
    ./hardware.nix
    ./network.nix
    ../../modules/stylix.nix
  ];

  networking.hostName = "thinkFREE";

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.safeith = {
    isNormalUser = true;
    description = "Hojjat";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [{
    users = [ "safeith" ];
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
    ];
  };

  programs = {
    zsh.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "safeith" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
