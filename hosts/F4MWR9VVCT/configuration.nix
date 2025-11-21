{ pkgs, config, ... }:

{
  imports = [
    ../../modules/system-optimization.nix
    ../../modules/cloudflared.nix
  ];

  system.primaryUser = config.userConfig.workUsername;

  users.users.${config.userConfig.workUsername} = {
    name = config.userConfig.workUsername;
    home = "/Users/${config.userConfig.workUsername}";
  };

  environment.systemPackages = with pkgs; [ ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    dns = [ "127.0.0.1" ];
    knownNetworkServices = [
      "Wi-Fi"
      "Lenovo USB-C to LAN"
      "USB 10/100/1000 LAN"
    ];
  };

  programs.zsh.enable = true;

  environment.etc."sudoers.d/darwin-rebuild".text = ''
    Defaults env_keep += "TERMINFO TERMINFO_DIRS"
    ${config.userConfig.workUsername} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild
  '';

  system.defaults.dock = {
    autohide = true;
    expose-group-apps = true;
    mru-spaces = false;
    show-recents = false;
    launchanim = false;
    persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/Applications/Brave Browser.app"
      "/Applications/kitty.app"
      "/Applications/Obsidian.app"
      "/Applications/Spotify.app"
      "/System/Applications/System Settings.app"
    ];
  };

  system.defaults.NSGlobalDomain = {
    _HIHideMenuBar = true;
    "com.apple.keyboard.fnState" = false;
    AppleSpacesSwitchOnActivate = false;
    NSAutomaticCapitalizationEnabled = true;
    NSAutomaticPeriodSubstitutionEnabled = true;
  };

  system.defaults.trackpad.Clicking = true;

  system.defaults.spaces.spans-displays = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    nonUS.remapTilde = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "nikitabobko/tap"
      "atlassian/homebrew-acli"
    ];

    brews = [ "acli" ];

    casks = [
      "nikitabobko/tap/aerospace"
      "brave-browser"
      "1password"
      "kitty"
      "betterdisplay"
      "localsend"
      "maccy"
      "spotify"
      "hiddenbar"
      "sublime-text"
      "obsidian"
    ];

    masApps = { };
  };

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.config.allowUnfree = true;
}
