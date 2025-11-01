{ pkgs, lib, config, ... }:

let
  launcherPath = "${config.home.homeDirectory}/.local/bin/webapp-launcher";
  
  iconSources = {
    chatgpt = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/chatgpt.png";
      sha256 = "013f6frbfbi22w92zvqpf51jmygpacz30617ql7kvxcr3vag7yca";
    };
    gmail = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png";
      sha256 = "1l8rdv3k21lmmrkn8szw10s4cfd9wzpjhj03f7bzhpzpqb0ph680";
    };
    telegram = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/telegram.png";
      sha256 = "jGUNFMpH62/XKqM0fZ1fKEAWt+rh47lgZVWzVNuTh/M=";
    };
    whatsapp = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/whatsapp.png";
      sha256 = "onbglLXom+IuTMduXAIAtujJSghEmtwW/PEd0dSe4Pw=";
    };
    youtube = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube.png";
      sha256 = "IXEiZv0BxEfja0Rh/4YSRzXEg8iSElLAEfCkNUcDFVI=";
    };
    youtube-music = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube-music.png";
      sha256 = "2XzJkhMPbmLjuHiD/kIh7qA9B5gZ3Uby60U2nQC2dqI=";
    };
    soundcloud = pkgs.fetchurl {
      url = "https://a-v2.sndcdn.com/assets/images/sc-icons/ios-a62dfc8fe7.png";
      sha256 = "YI+1gY42lGxm/lFzFG1K6BSJqLw+xcuIAQk6oBI6PNE=";
    };
  };

  mkMacApp = { name, url, icon }:
    let
      appName = lib.replaceStrings [" "] [""] name;
      iconPng = iconSources.${icon};
    in {
      ".local/share/webapps/${name}.app/Contents/MacOS/${appName}" = {
        text = ''
          #!/usr/bin/env bash
          ${launcherPath} ${lib.toLower appName} ${url}
        '';
        executable = true;
      };
      ".local/share/webapps/${name}.app/Contents/Info.plist" = {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleExecutable</key>
            <string>${appName}</string>
            <key>CFBundleName</key>
            <string>${name}</string>
            <key>CFBundleDisplayName</key>
            <string>${name}</string>
            <key>CFBundleIdentifier</key>
            <string>com.webapp.${lib.toLower appName}</string>
            <key>CFBundleVersion</key>
            <string>1.0</string>
            <key>CFBundleShortVersionString</key>
            <string>1.0</string>
            <key>CFBundlePackageType</key>
            <string>APPL</string>
            <key>CFBundleIconFile</key>
            <string>icon</string>
            <key>LSMinimumSystemVersion</key>
            <string>10.15</string>
          </dict>
          </plist>
        '';
      };
      ".local/share/webapps/${name}.app/Contents/Resources/.icon-source-${icon}.png".source = iconPng;
    };
  
  webapps = [
    { name = "Telegram"; url = "https://web.telegram.org"; icon = "telegram"; }
    { name = "WhatsApp"; url = "https://web.whatsapp.com"; icon = "whatsapp"; }
    { name = "YouTube"; url = "https://youtube.com"; icon = "youtube"; }
    { name = "ChatGPT"; url = "https://chatgpt.com"; icon = "chatgpt"; }
    { name = "Gmail"; url = "https://mail.google.com"; icon = "gmail"; }
    { name = "SoundCloud"; url = "https://soundcloud.com"; icon = "soundcloud"; }
    { name = "YouTube Music"; url = "https://music.youtube.com"; icon = "youtube-music"; }
  ];
in
{
  home.activation.linkMacApps = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      APPS_DIR="$HOME/Applications/Web Apps"
      
      mkdir -p "$APPS_DIR"
      
      for app in ${config.home.homeDirectory}/.local/share/webapps/*.app; do
        if [ -d "$app" ]; then
          app_name=$(basename "$app")
          resources_dir="$app/Contents/Resources"
          dest_app="$APPS_DIR/$app_name"
          
          for icon_source in "$resources_dir"/.icon-source-*.png; do
            if [ -f "$icon_source" ]; then
              icon_file="$resources_dir/icon.icns"
              
              if [ ! -f "$icon_file" ]; then
                tmpdir=$(mktemp -d)
                iconset="$tmpdir/icon.iconset"
                mkdir -p "$iconset"
                
                /usr/bin/sips -z 16 16     "$icon_source" --out "$iconset/icon_16x16.png" >/dev/null 2>&1
                /usr/bin/sips -z 32 32     "$icon_source" --out "$iconset/icon_16x16@2x.png" >/dev/null 2>&1
                /usr/bin/sips -z 32 32     "$icon_source" --out "$iconset/icon_32x32.png" >/dev/null 2>&1
                /usr/bin/sips -z 64 64     "$icon_source" --out "$iconset/icon_32x32@2x.png" >/dev/null 2>&1
                /usr/bin/sips -z 128 128   "$icon_source" --out "$iconset/icon_128x128.png" >/dev/null 2>&1
                /usr/bin/sips -z 256 256   "$icon_source" --out "$iconset/icon_128x128@2x.png" >/dev/null 2>&1
                /usr/bin/sips -z 256 256   "$icon_source" --out "$iconset/icon_256x256.png" >/dev/null 2>&1
                /usr/bin/sips -z 512 512   "$icon_source" --out "$iconset/icon_256x256@2x.png" >/dev/null 2>&1
                /usr/bin/sips -z 512 512   "$icon_source" --out "$iconset/icon_512x512.png" >/dev/null 2>&1
                cp "$icon_source" "$iconset/icon_512x512@2x.png"
                
                /usr/bin/iconutil -c icns "$iconset" -o "$icon_file" >/dev/null 2>&1
                rm -rf "$tmpdir"
              fi
              break
            fi
          done
          
          rm -rf "$dest_app"
          cp -RL "$app" "$dest_app"
          chmod -R u+w "$dest_app"
          chmod +x "$dest_app/Contents/MacOS"/*
          touch "$dest_app"
        fi
      done
      
      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APPS_DIR"/*.app >/dev/null 2>&1 || true
      killall Dock >/dev/null 2>&1 || true
    ''
  );

  home.file = lib.mkMerge ([
    {
      ".local/bin/webapp-launcher" = {
        text = ''
          #!/usr/bin/env bash
          APP_ID="$1"
          URL="$2"
          
          if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS: Check if app is already running via process name
            if pgrep -f "Brave.*--app=$URL" > /dev/null 2>&1; then
              # Focus existing window using open
              open -a "Brave Browser" --args --profile-directory="Profile 1" --app="$URL"
            else
              open -gna "Brave Browser" --args --profile-directory="Profile 1" --app="$URL"
            fi
          else
            # Linux (Hyprland): Check window class
            CLASS="brave-$(echo "$URL" | sed 's|https://||' | sed 's|/$||')__-Default"
            if hyprctl clients -j | jq -e ".[] | select(.class == \"$CLASS\")" > /dev/null 2>&1; then
              hyprctl dispatch focuswindow "class:$CLASS"
            else
              brave --app="$URL" &
            fi
          fi
        '';
        executable = true;
      };
    }
    (lib.optionalAttrs pkgs.stdenv.isLinux {
      ".local/share/icons/chatgpt.png".source = iconSources.chatgpt;
      ".local/share/icons/gmail.png".source = iconSources.gmail;
      ".local/share/icons/telegram.png".source = iconSources.telegram;
      ".local/share/icons/whatsapp.png".source = iconSources.whatsapp;
      ".local/share/icons/youtube.png".source = iconSources.youtube;
      ".local/share/icons/youtube-music.png".source = iconSources."youtube-music";
      ".local/share/icons/soundcloud.png".source = iconSources.soundcloud;
    })
  ] ++ lib.optionals pkgs.stdenv.isDarwin (
    lib.flatten (map mkMacApp webapps)
  ));

  xdg.desktopEntries = lib.optionalAttrs pkgs.stdenv.isLinux {
    telegram-web = {
      name = "Telegram";
      exec = "${launcherPath} telegram https://web.telegram.org";
      icon = "telegram";
      categories = [ "Network" "InstantMessaging" ];
      terminal = false;
    };

    whatsapp-web = {
      name = "WhatsApp";
      exec = "${launcherPath} whatsapp https://web.whatsapp.com";
      icon = "whatsapp";
      categories = [ "Network" "InstantMessaging" ];
      terminal = false;
    };

    youtube = {
      name = "YouTube";
      exec = "${launcherPath} youtube https://youtube.com";
      icon = "youtube";
      categories = [ "AudioVideo" "Video" ];
      terminal = false;
    };

    chatgpt = {
      name = "ChatGPT";
      exec = "${launcherPath} chatgpt https://chatgpt.com";
      icon = "chatgpt";
      categories = [ "Network" ];
      terminal = false;
    };

    gmail = {
      name = "Gmail";
      exec = "${launcherPath} gmail https://mail.google.com";
      icon = "gmail";
      categories = [ "Network" ];
      terminal = false;
    };

    soundcloud = {
      name = "SoundCloud";
      exec = "${launcherPath} soundcloud https://soundcloud.com";
      icon = "soundcloud";
      categories = [ "AudioVideo" ];
      terminal = false;
    };

    youtube-music = {
      name = "YouTube Music";
      exec = "${launcherPath} youtube-music https://music.youtube.com";
      icon = "youtube-music";
      categories = [ "AudioVideo" ];
      terminal = false;
    };
  };
}
