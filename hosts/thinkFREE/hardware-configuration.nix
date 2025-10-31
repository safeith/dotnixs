{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6ebada9e-8d50-4fee-9a62-57e6c0d13fc0";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-e6708e24-e0a4-44bc-a1d6-53e35bb20979".device =
    "/dev/disk/by-uuid/e6708e24-e0a4-44bc-a1d6-53e35bb20979";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5147-17CB";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7718fab6-e059-4d48-aaca-0428d38111d8"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
