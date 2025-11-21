{ pkgs, lib, config, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;

in
{
  config = lib.mkIf isDarwin {
    environment.systemPackages = [
      pkgs.cloudflared
    ];

    launchd.daemons.cloudflared = {
      serviceConfig = {
        Label = "org.nixos.cloudflared";
        ProgramArguments = [
          "${pkgs.cloudflared}/bin/cloudflared"
          "proxy-dns"
          "--port"
          "53"
          "--upstream"
          "https://dns.safeith.com/dns-query"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/cloudflared.stdout.log";
        StandardErrorPath = "/tmp/cloudflared.stderr.log";
      };
    };
  };
}
