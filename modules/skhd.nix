{ pkgs, ... }:

{
  home.packages = [ pkgs.skhd ];

  home.file.".skhdrc".text = ''
    alt - b : open -a "Brave Browser"
    alt - k : open -a "kitty"
    ctrl + alt - p : open -a "Screenshot"
    ctrl + alt - l : pmset displaysleepnow
  '';

  launchd.agents.skhd = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.skhd}/bin/skhd" ];
      KeepAlive = true;
      ProcessType = "Interactive";
    };
  };
}
