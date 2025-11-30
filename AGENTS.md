# Agent Guidelines for NixOS Configuration Repository

## Important Notes
- **Secrets**: This repo uses `secrets.nix` (gitignored) loaded via PWD. Always use `--impure` flag when building.
- **Hostnames**: Host-specific configurations are in `hosts/<hostname>/`. Replace with actual hostname in build commands.

## Build/Test Commands
- **Build NixOS**: `sudo nixos-rebuild switch --flake .#<hostname> --impure`
- **Build Darwin**: `darwin-rebuild switch --flake .#<hostname> --impure`
- **Test without switching**: `nixos-rebuild test --flake .#<hostname> --impure`
- **Check flake**: `nix flake check` (validates flake structure and evaluates configurations)
- **Update flake inputs**: `nix flake update`
- **Format Nix**:`nixpkgs-fmt <file.nix>`
- **Format Lua**: `stylua <file.lua>`

## Secrets Management
- `secrets.nix` contains sensitive data (emails, usernames) and is gitignored
- Template available in `secrets.nix.example`
- Loaded dynamically using PWD in `flake.nix` (requires `--impure`)
- Never commit sensitive data to git

## Code Style - Nix
- 2-space indentation; imports at top; allowUnfree when needed
- Use `let...in` for local variables/helpers (see flake.nix:45-64 for patterns)
- Use `with pkgs;` in package lists only, not top-level scope (modules/packages.nix:7)
- Order: imports → config → environment → programs → services
- Relative paths for modules: `./modules/stylix.nix`, `../../modules/git.nix`
- Conditionals: `lib.optionals isPersonal personalPackages` (modules/packages.nix:61)
- Platform checks: `pkgs.stdenv.isLinux`, `pkgs.stdenv.isDarwin` for host-specific config
- Always set `system.stateVersion = "25.11"` (NixOS) in configuration.nix
- Function parameters: `{ pkgs, lib, ... }:` pattern with ellipsis for forward compatibility
- Enable experimental features: `nix.settings.experimental-features = [ "nix-command" "flakes" ];`

## Code Style - Lua (NvChad)
- 2-space indent, 120 col width, double quotes, no call parens, Unix line endings
- Follow NvChad conventions: `require "nvchad.options"` before custom options (configs/nvim/lua/options.lua:1)
