{ ... }:

{
  networking.networkmanager.enable = true;

  services.dnsproxy = {
    enable = true;
    settings = {
      bootstrap = [ "1.1.1.1:53" "1.0.0.1:53" ];
      listen-addrs = [ "127.0.0.1" "::1" ];
      listen-ports = [ 53 ];
      upstream = [
        "quic://dns.safeith.com"
        "tls://dns.safeith.com"
        "https://dns.safeith.com/dns-query"
        "h3://dns.safeith.com/dns-query"
      ];
    };
  };
}
