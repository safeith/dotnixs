{
  description =
    "Multi-platform Nix configuration for NixOS (Hyprland) and macOS (Aerospace)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";

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
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, darwin, lanzaboote
    , stylix, mac-app-util, ... }:
    let
      lib = nixpkgs.lib;

      homeManagerExtraSpecialArgs = system: pkgs-unstable: secretsPath: {
        inherit system inputs pkgs-unstable secretsPath;
      };

      homeManagerModules = host: system: pkgs-unstable: includeStyleix:
        isLinux: secretsPath: [{
          home-manager = {
            useGlobalPkgs = isLinux;
            useUserPackages = true;
            extraSpecialArgs = homeManagerExtraSpecialArgs system pkgs-unstable secretsPath;
            users.${host.user} = {
              imports = [ host.homeConfig ] ++ (if includeStyleix then
                [ stylix.homeModules.stylix ]
              else
                [ ]);
            };
          };
        }];

      loadSecrets = path:
        if builtins.pathExists path then
          import path
        else
          builtins.throw "secrets.nix not found at ${toString path}. Copy secrets.nix.example to secrets.nix and fill in your values.";

    in {
      nixosConfigurations = {
        thinkFREE = let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          secretsPath = /. + builtins.getEnv "PWD" + "/secrets.nix";
          secrets = loadSecrets secretsPath;
          thinkFREEHost = {
            user = secrets.personalUsername;
            homeConfig = ./hosts/thinkFREE/home.nix;
          };
        in lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs-unstable; };
          modules = [
            stylix.nixosModules.stylix
            ./hosts/thinkFREE/configuration.nix

            home-manager.nixosModules.home-manager
          ] ++ (homeManagerModules thinkFREEHost system pkgs-unstable false true secretsPath)
            ++ [

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
        F4MWR9VVCT = let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          secretsPath = /. + builtins.getEnv "PWD" + "/secrets.nix";
          secrets = loadSecrets secretsPath;
          F4MWR9VVCTHost = {
            user = secrets.workUsername;
            homeConfig = ./hosts/F4MWR9VVCT/home.nix;
          };
        in darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./hosts/F4MWR9VVCT/configuration.nix

            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
          ] ++ (homeManagerModules F4MWR9VVCTHost system pkgs-unstable true false secretsPath);
        };
      };
    };
}

