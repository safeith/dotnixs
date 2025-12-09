{ pkgs, ... }:

{
  home.packages = [ pkgs.skhd ];

  home.file.".skhdrc".text = ''
    alt - b : open -a "Brave Browser"
    alt - k : open -a "kitty"
    alt - p : open -a "Screenshot"
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
