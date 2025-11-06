{ pkgs, pkgs-unstable, lib, ... }:

let
  isPersonal = pkgs.stdenv.isLinux;
  isWork = pkgs.stdenv.isDarwin;

  sharedPackages = with pkgs; [
    awscli2
    axel
    cloudflared
    dig
    dos2unix
    fastfetch
    fzf
    gcc
    pkgs-unstable.gemini-cli
    gh
    pkgs-unstable.github-copilot-cli
    go
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    iftop
    iperf3
    jq
    kubectl
    lazygit
    mtr
    nix-prefetch
    nixpkgs-fmt
    nodejs
    p7zip
    pwgen
    python3
    ripgrep
    stow
    tenv
    terraform-docs
    unzip
    uv
    wget
    whois
    yarn
    zip
    zoxide
  ];

  zoom-scaled = pkgs.symlinkJoin {
    name = "zoom-us";
    paths = [ pkgs-unstable.zoom-us ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zoom \
        --set QT_SCALE_FACTOR 1.25
    '';
  };

  personalPackages = with pkgs;
    [
      android-tools
      electrum
      heimdall
      kdePackages.ksshaskpass
      libnotify
      localsend
      protonvpn-gui
      simple-scan
      spotify
      tor-browser
      vlc
      wl-clipboard
    ] ++ [ zoom-scaled ];

  workPackages = with pkgs; [ ];

in {
  home.packages = sharedPackages ++ lib.optionals isPersonal personalPackages
    ++ lib.optionals isWork workPackages ++ [ pkgs-unstable.opencode ];
}
