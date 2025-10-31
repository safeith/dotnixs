{ pkgs, ... }:

{
  system.primaryUser = "hojjat.alimohammadi";

  users.users."hojjat.alimohammadi" = {
    name = "hojjat.alimohammadi";
    home = "/Users/hojjat.alimohammadi";
  };

  environment.systemPackages = with pkgs; [ ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.etc."sudoers.d/darwin-rebuild".text = ''
    Defaults env_keep += "TERMINFO TERMINFO_DIRS"
    hojjat.alimohammadi ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild
  '';

  system.defaults.dock = {
    autohide = true;
    expose-group-apps = true;
    persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/Applications/Brave Browser.app"
      "/Applications/kitty.app"
      "/Applications/1Password.app"
      "/System/Applications/System Settings.app"
    ];
  };

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.defaults.spaces.spans-displays = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    nonUS.remapTilde = true;
  };

  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [ "nikitabobko/tap" ];

    brews = [ ];

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
    ];

    masApps = { };
  };

  system.configurationRevision = null;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.config.allowUnfree = true;
}
