{ pkgs, lib, ... }:

{
  home.file.".local/share/icons/chatgpt.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/chatgpt.png";
    sha256 = "013f6frbfbi22w92zvqpf51jmygpacz30617ql7kvxcr3vag7yca";
  };

  home.file.".local/share/icons/gmail.png".source = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png";
    sha256 = "1l8rdv3k21lmmrkn8szw10s4cfd9wzpjhj03f7bzhpzpqb0ph680";
  };

  xdg.desktopEntries = {
    telegram-web = {
      name = "Telegram";
      exec = "brave --new-window --app=https://web.telegram.org --class=telegram-web";
      icon = "telegram";
      categories = [ "Network" "InstantMessaging" ];
      terminal = false;
    };

    whatsapp-web = {
      name = "WhatsApp";
      exec = "brave --new-window --app=https://web.whatsapp.com --class=whatsapp-web";
      icon = "whatsapp";
      categories = [ "Network" "InstantMessaging" ];
      terminal = false;
    };

    youtube = {
      name = "YouTube";
      exec = "brave --new-window --app=https://youtube.com --class=youtube";
      icon = "youtube";
      categories = [ "AudioVideo" "Video" ];
      terminal = false;
    };

    chatgpt = {
      name = "ChatGPT";
      exec = "brave --new-window --app=https://chatgpt.com --class=chatgpt";
      icon = "chatgpt";
      categories = [ "Network" "Office" ];
      terminal = false;
    };

    gmail = {
      name = "Gmail";
      exec = "brave --new-window --app=https://mail.google.com --class=gmail";
      icon = "gmail";
      categories = [ "Network" "Email" ];
      terminal = false;
    };
  };
}
