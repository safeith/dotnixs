{ pkgs, lib, ... }:

{
  # Nix store optimization and garbage collection
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;

      # Binary cache configuration
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Performance optimizations
      max-jobs = "auto";
      cores = 0;

      # Build users optimization
      build-users-group = "nixbld";
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      interval = {
        Hour = 10;
        Weekday = 5; # 5 = Friday
      };
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      dates = "weekly";
    };

    # Automatic store optimization
    optimise = {
      automatic = true;
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      interval = {
        Hour = 11;
        Weekday = 5; # 5 = Friday
      };
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      dates = [ "weekly" ];
    };
  };

  # System maintenance scripts
  environment.systemPackages = with pkgs; [
    # Add maintenance scripts
    (writeScriptBin "nix-cleanup" ''
      #!${stdenv.shell}
      echo "Running Nix store cleanup..."
      nix-collect-garbage -d
      nix-store --optimise
      echo "Cleanup completed!"
    '')

    (writeScriptBin "nix-update-system" ''
      #!${stdenv.shell}
      echo "Updating flake inputs..."
      nix flake update
      echo "Rebuilding system..."
      ${if pkgs.stdenv.isLinux then
        "sudo nixos-rebuild switch --flake .#$(hostname) --impure"
      else
        "darwin-rebuild switch --flake .#$(hostname) --impure"}
    '')
  ];
}
