# Agent Guidelines for NixOS Configuration Repository

## Build/Test Commands
- **Build NixOS**: `sudo nixos-rebuild switch --flake .#thinkFREE --impure`
- **Build Darwin**: `darwin-rebuild switch --flake .#F4MWR9VVCT --impure`
- **Test without switching**: `nixos-rebuild test --flake .#<hostname>`
- **Check flake**: `nix flake check` (validates flake structure and evaluates configurations)
- **Update flake inputs**: `nix flake update`
- **Format Nix**: `nvim +":lua vim.lsp.buf.format()" +wq <file.nix>` or `nixpkgs-fmt <file.nix>`
- **Format Lua**: `stylua <file.lua>`

## Code Style - Nix
- 2-space indentation; imports at top; allowUnfree when needed
- Use `let...in` for local variables/helpers (see flake.nix:45-64 for patterns)
- Use `with pkgs;` in package lists only, not top-level scope (modules/packages.nix:7)
- Order: imports → config → environment → programs → services
- Relative paths for modules: `./modules/stylix.nix`, `../../modules/git.nix`
- Conditionals: `lib.optionals isPersonal personalPackages` (modules/packages.nix:61)
- Platform checks: `pkgs.stdenv.isLinux`, `pkgs.stdenv.isDarwin` for host-specific config
- Always set `system.stateVersion = "25.05"` (NixOS) in configuration.nix
- Function parameters: `{ pkgs, lib, ... }:` pattern with ellipsis for forward compatibility
- Enable experimental features: `nix.settings.experimental-features = [ "nix-command" "flakes" ];`

## Code Style - Lua (NvChad)
- 2-space indent, 120 col width, double quotes, no call parens, Unix line endings
- Follow NvChad conventions: `require "nvchad.options"` before custom options (configs/nvim/lua/options.lua:1)
