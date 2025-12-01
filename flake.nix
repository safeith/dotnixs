{
  description =
    "Multi-platform Nix configuration for NixOS (Hyprland) and macOS (Aerospace)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvchad-starter = {
      url = "path:./configs/nvim";
      flake = false;
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs
    , nixpkgs-unstable
    , home-manager
    , darwin
    , lanzaboote
    , stylix
    , ...
    }:
    let
      lib = nixpkgs.lib;

      # Common package set creation with consistent configuration
      mkPkgs = system: nixpkgs:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
          };
        };

      # Load user config using the centralized user module
      mkUserModule = { ... }: {
        imports = [ ./modules/user.nix ];
      };

      # Simplified home manager configuration
      mkHomeManagerConfig =
        { host, system, pkgs-unstable, includeStyleix ? false, isLinux ? true }:
        {
          home-manager = {
            useGlobalPkgs = isLinux;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit system inputs pkgs-unstable;
            };
            users.${host.user} = {
              imports = [
                host.homeConfig
                ./modules/user.nix
              ] ++ lib.optionals includeStyleix [
                stylix.homeModules.stylix
                ./modules/stylix-home.nix
              ];
            } // lib.optionalAttrs (!isLinux) {
              nixpkgs.config.allowUnfree = true; # Only needed for Darwin
            };
          };
        };

    in
    {
      nixosConfigurations = {
        thinkFREE =
          let
            system = "x86_64-linux";
            pkgs = mkPkgs system nixpkgs;
            pkgs-unstable = mkPkgs system nixpkgs-unstable;

            # Create a temporary config to access user config for username
            tempConfig = lib.evalModules {
              modules = [ ./modules/user.nix ];
            };
            userConfig = tempConfig.config.userConfig;

            host = {
              user = userConfig.personalUsername;
              homeConfig = ./hosts/thinkFREE/home.nix;
            };
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = { inherit pkgs-unstable; };
            modules = [
              stylix.nixosModules.stylix
              ./hosts/thinkFREE/configuration.nix
              ./modules/user.nix

              home-manager.nixosModules.home-manager
              (mkHomeManagerConfig {
                inherit host system pkgs-unstable;
                includeStyleix = false;
                isLinux = true;
              })

              lanzaboote.nixosModules.lanzaboote
              ({ pkgs, lib, ... }: {
                environment.systemPackages = [ pkgs.sbctl ];
                boot.loader.systemd-boot.enable = lib.mkForce false;
                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              })
            ];
          };
      };

      darwinConfigurations = {
        F4MWR9VVCT =
          let
            system = "aarch64-darwin";
            pkgs = mkPkgs system nixpkgs;
            pkgs-unstable = mkPkgs system nixpkgs-unstable;

            # Create a temporary config to access user config for username
            tempConfig = lib.evalModules {
              modules = [ ./modules/user.nix ];
            };
            userConfig = tempConfig.config.userConfig;

            host = {
              user = userConfig.workUsername;
              homeConfig = ./hosts/F4MWR9VVCT/home.nix;
            };
          in
          darwin.lib.darwinSystem {
            inherit system;
            modules = [
              ./hosts/F4MWR9VVCT/configuration.nix
              ./modules/user.nix

              home-manager.darwinModules.home-manager
              (mkHomeManagerConfig {
                inherit host system pkgs-unstable;
                includeStyleix = true;
                isLinux = false;
              })
            ];
          };
      };
    };
}

