# Package management module - organized by platform and use case
# This module provides a unified interface for installing packages across
# different platforms (Linux/macOS) and use cases (personal/work)
{ pkgs, pkgs-unstable, lib, ... }:

let
  isPersonal = pkgs.stdenv.isLinux;
  isWork = pkgs.stdenv.isDarwin;

  # Shared packages available on both Linux and macOS
  sharedPackages = with pkgs; [
    # Cloud & Infrastructure
    ansible
    awscli2
    autossh
    cloudflared
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    kubectl
    tenv
    terraform-docs

    # Development Tools
    cargo
    gcc
    gh
    go
    nodejs
    python3
    rustc
    uv
    yarn

    # Custom development tools
    (pkgs.buildGoModule rec {
      pname = "json2go";
      version = "0.1.0";

      src = pkgs.fetchFromGitHub {
        owner = "olexsmir";
        repo = "json2go";
        rev = "v${version}";
        hash = "sha256-4xpv2EHzviu0kwgzWqrmhRqUe/SM95/ZP6PNDL6xlt0=";
      };

      vendorHash = null;

      meta = with pkgs.lib; {
        description = "A CLI tool to convert JSON to Go structs";
        homepage = "https://github.com/olexsmir/json2go";
        license = licenses.mit;
        mainProgram = "json2go";
      };
    })

    # System Utilities
    axel
    dig
    dos2unix
    fastfetch
    fzf
    iftop
    iperf3
    jq
    lazygit
    mtr
    nix-prefetch
    nixpkgs-fmt
    nushell
    pwgen
    ripgrep
    stow
    unzip
    wget
    whois
    yt-dlp
    zip
    zoxide

    # Archive Tools
    p7zip

    # Unstable packages
    pkgs-unstable.gemini-cli
    pkgs-unstable.github-copilot-cli
    pkgs-unstable.opencode
  ];

  # Linux-specific packages (personal use)
  personalPackages = with pkgs; [
    # Android Development
    android-tools
    heimdall

    # Desktop Applications
    bitwarden-desktop
    electrum
    localsend
    protonvpn-gui
    obsidian
    simple-scan
    spotify
    tor-browser
    vlc
    geeqie
    pkgs-unstable.zoom-us

    # System Integration
    kdePackages.ksshaskpass
    libnotify
    wl-clipboard
    xorg.xrdb

    # Qt/GTK Theming
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

  ];

  # macOS-specific packages (work environment)
  workPackages = with pkgs; [
    pkgs-unstable.cursor-cli
  ];

in
{
  home.packages = sharedPackages
    ++ lib.optionals isPersonal personalPackages
    ++ lib.optionals isWork workPackages;
}
