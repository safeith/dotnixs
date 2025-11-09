{ pkgs, lib, ... }:

let
  acli = pkgs.buildFHSEnv {
    name = "acli";

    targetPkgs = pkgs: with pkgs; [
      # Core dependencies
      glibc
      zlib
      stdenv.cc.cc.lib

      # Common libraries that might be needed
      openssl
      curl
      cacert
    ];

    runScript = pkgs.writeShellScript "acli-wrapper" ''
      # Download and setup acli if not exists
      ACLI_DIR="$HOME/.local/share/acli"
      ACLI_BIN="$ACLI_DIR/acli"
      
      if [ ! -f "$ACLI_BIN" ]; then
        mkdir -p "$ACLI_DIR"
        echo "Downloading Atlassian CLI..."
        
        # Detect architecture
        ARCH=$(uname -m)
        if [ "$ARCH" = "x86_64" ]; then
          ACLI_ARCH="amd64"
        elif [ "$ARCH" = "aarch64" ]; then
          ACLI_ARCH="arm64"
        else
          echo "Unsupported architecture: $ARCH"
          exit 1
        fi
        
        # Download acli binary
        curl -L "https://acli.atlassian.com/linux/latest/acli_linux_''${ACLI_ARCH}/acli" -o "$ACLI_BIN"
        chmod +x "$ACLI_BIN"
        echo "Atlassian CLI installed to $ACLI_BIN"
      fi
      
      # Execute acli with all arguments
      exec "$ACLI_BIN" "$@"
    '';

    meta = with lib; {
      description = "Atlassian CLI - Command-line interface for Atlassian Cloud products";
      homepage = "https://developer.atlassian.com/cloud/acli/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" "aarch64-linux" ];
    };
  };

in
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ acli ];
}
