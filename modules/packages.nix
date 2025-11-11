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
    awscli2
    autossh
    cloudflared
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    kubectl
    tenv
    terraform-docs

    # Development Tools
    gcc
    gh
    go
    nodejs
    python3
    uv
    yarn

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
    zip
    zoxide

    # Archive Tools
    p7zip

    # Unstable packages
    pkgs-unstable.gemini-cli
    pkgs-unstable.github-copilot-cli
    pkgs-unstable.opencode
  ];

  # Custom zoom with scaling for HiDPI displays
  zoom-scaled = pkgs.symlinkJoin {
    name = "zoom-us";
    paths = [ pkgs-unstable.zoom-us ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zoom \
        --set QT_SCALE_FACTOR 1.25
    '';
  };

  # Linux-specific packages (personal use)
  personalPackages = with pkgs; [
    # Android Development
    android-tools
    heimdall

    # Desktop Applications
    electrum
    localsend
    protonvpn-gui
    simple-scan
    spotify
    tor-browser
    vlc

    # System Integration
    kdePackages.ksshaskpass
    libnotify
    wl-clipboard

    # Custom packages
    zoom-scaled
  ];

  # macOS-specific packages (work environment)
  workPackages = with pkgs; [
    # Add macOS-specific packages here when needed
    # Currently using homebrew for most GUI applications
  ];

in
{
  home.packages = sharedPackages
    ++ lib.optionals isPersonal personalPackages
    ++ lib.optionals isWork workPackages;
}
