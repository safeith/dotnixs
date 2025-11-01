{ pkgs, lib, config, ... }:

let
  launcherPath = "${config.home.homeDirectory}/.local/bin/webapp-launcher";
in
{
  home.file.".local/bin/webapp-launcher" = {
    text = ''
      #!/usr/bin/env bash
      APP_ID="$1"
      URL="$2"
      CLASS="brave-$(echo "$URL" | sed 's|https://||' | sed 's|/$||')__-Default"
      
      if hyprctl clients -j | jq -e ".[] | select(.class == \"$CLASS\")" > /dev/null 2>&1; then
        hyprctl dispatch focuswindow "class:$CLASS"
      else
        brave --app="$URL" &
      fi
    '';
    executable = true;
  };

  home.file.".local/share/icons/chatgpt.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/chatgpt.png";
    sha256 = "013f6frbfbi22w92zvqpf51jmygpacz30617ql7kvxcr3vag7yca";
  };

  home.file.".local/share/icons/gmail.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png";
    sha256 = "1l8rdv3k21lmmrkn8szw10s4cfd9wzpjhj03f7bzhpzpqb0ph680";
  };

  home.file.".local/share/icons/telegram.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/telegram.png";
    sha256 = "jGUNFMpH62/XKqM0fZ1fKEAWt+rh47lgZVWzVNuTh/M=";
  };

  home.file.".local/share/icons/whatsapp.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/whatsapp.png";
    sha256 = "onbglLXom+IuTMduXAIAtujJSghEmtwW/PEd0dSe4Pw=";
  };

  home.file.".local/share/icons/youtube.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube.png";
    sha256 = "IXEiZv0BxEfja0Rh/4YSRzXEg8iSElLAEfCkNUcDFVI=";
  };

  home.file.".local/share/icons/youtube-music.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube-music.png";
    sha256 = "2XzJkhMPbmLjuHiD/kIh7qA9B5gZ3Uby60U2nQC2dqI=";
  };

  home.file.".local/share/icons/soundcloud.png".source = pkgs.fetchurl {
    url = "https://a-v2.sndcdn.com/assets/images/sc-icons/ios-a62dfc8fe7.png";
    sha256 = "YI+1gY42lGxm/lFzFG1K6BSJqLw+xcuIAQk6oBI6PNE=";
  };

  xdg.desktopEntries = {
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
