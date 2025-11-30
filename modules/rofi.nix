{ config, pkgs, lib, ... }:

let colors = config.lib.stylix.colors;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = lib.mkForce "JetBrainsMono Nerd Font 11";
    terminal = lib.mkForce "${pkgs.kitty}/bin/kitty";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = " ";
      display-run = " ";
      display-window = " ";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      matching = "fuzzy";
      scroll-method = 0;
      disable-history = false;
      sidebar-mode = false;
    };

    theme = lib.mkForce (
      let inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg = mkLiteral "#${colors.base00}";
          bg-alt = mkLiteral "#${colors.base01}";
          bg-selected = mkLiteral "#${colors.base02}";
          fg = mkLiteral "#${colors.base05}";
          fg-alt = mkLiteral "#${colors.base04}";

          border = mkLiteral "#${colors.base0B}";
          blue = mkLiteral "#${colors.base0B}";
          red = mkLiteral "#${colors.base08}";

          border-colour = mkLiteral "@border";
          handle-colour = mkLiteral "@border";
          background-colour = mkLiteral "@bg";
          foreground-colour = mkLiteral "@fg";
          alternate-background = mkLiteral "@bg-alt";
          normal-background = mkLiteral "@bg";
          normal-foreground = mkLiteral "@fg";
          urgent-background = mkLiteral "@bg";
          urgent-foreground = mkLiteral "@red";
          active-background = mkLiteral "@bg";
          active-foreground = mkLiteral "@blue";
          selected-normal-background = mkLiteral "@bg-selected";
          selected-normal-foreground = mkLiteral "@fg";
          selected-urgent-background = mkLiteral "@bg-selected";
          selected-urgent-foreground = mkLiteral "@red";
          selected-active-background = mkLiteral "@bg-selected";
          selected-active-foreground = mkLiteral "@blue";
          alternate-normal-background = mkLiteral "@bg";
          alternate-normal-foreground = mkLiteral "@fg";
          alternate-urgent-background = mkLiteral "@bg";
          alternate-urgent-foreground = mkLiteral "@red";
          alternate-active-background = mkLiteral "@bg";
          alternate-active-foreground = mkLiteral "@blue";
        };

        "window" = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = mkLiteral "false";
          width = mkLiteral "500px";
          border-radius = mkLiteral "10px";
          border = mkLiteral "2px";
          border-color = mkLiteral "@border-colour";
          background-color = mkLiteral "@background-colour";
        };

        "mainbox" = {
          background-color = mkLiteral "@background-colour";
          children = map mkLiteral [ "inputbar" "listview" ];
          padding = mkLiteral "10px";
          spacing = mkLiteral "10px";
        };

        "inputbar" = {
          background-color = mkLiteral "@bg-alt";
          text-color = mkLiteral "@foreground-colour";
          border-radius = mkLiteral "8px";
          padding = mkLiteral "8px";
          spacing = mkLiteral "8px";
          children = map mkLiteral [ "prompt" "entry" ];
        };

        "prompt" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@blue";
          font = "JetBrainsMono Nerd Font 14";
        };

        "entry" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground-colour";
          placeholder-color = mkLiteral "@fg-alt";
          placeholder = "Search...";
          cursor = mkLiteral "text";
        };

        "listview" = {
          background-color = mkLiteral "@background-colour";
          columns = 1;
          lines = 8;
          cycle = mkLiteral "false";
          dynamic = mkLiteral "true";
          scrollbar = mkLiteral "false";
          layout = mkLiteral "vertical";
          reverse = mkLiteral "false";
          fixed-height = mkLiteral "true";
          fixed-columns = mkLiteral "true";
          spacing = mkLiteral "3px";
        };

        "element" = {
          background-color = mkLiteral "@background-colour";
          text-color = mkLiteral "@foreground-colour";
          padding = mkLiteral "6px";
          border-radius = mkLiteral "6px";
          spacing = mkLiteral "8px";
        };

        "element normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-foreground";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@urgent-background";
          text-color = mkLiteral "@urgent-foreground";
        };

        "element normal.active" = {
          background-color = mkLiteral "@active-background";
          text-color = mkLiteral "@active-foreground";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@selected-urgent-background";
          text-color = mkLiteral "@selected-urgent-foreground";
        };

        "element selected.active" = {
          background-color = mkLiteral "@selected-active-background";
          text-color = mkLiteral "@selected-active-foreground";
        };

        "element alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-foreground";
        };

        "element alternate.urgent" = {
          background-color = mkLiteral "@alternate-urgent-background";
          text-color = mkLiteral "@alternate-urgent-foreground";
        };

        "element alternate.active" = {
          background-color = mkLiteral "@alternate-active-background";
          text-color = mkLiteral "@alternate-active-foreground";
        };

        "element-icon" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "20px";
          cursor = mkLiteral "inherit";
        };

        "element-text" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
      }
    );
  };

  home.file.".config/rofi/scripts/power-menu.sh" = {
    text = ''
      #!/usr/bin/env bash
      echo -en " Lock\0icon\x1fsystem-lock-screen\n" " Logout\0icon\x1fsystem-log-out\n" " Suspend\0icon\x1fsystem-suspend\n" "󰒲 Hybrid-sleep\0icon\x1fsystem-suspend-hibernate\n" " Reboot\0icon\x1fsystem-reboot\n" " Shutdown\0icon\x1fsystem-shutdown\n"

      if [ -n "$@" ]; then
        case "$@" in
          " Lock") hyprlock & ;;
          " Logout") hyprctl dispatch exit & ;;
          " Suspend") systemctl suspend & ;;
          "󰒲 Hybrid-sleep") systemctl hybrid-sleep & ;;
          " Reboot") systemctl reboot & ;;
          " Shutdown") systemctl poweroff & ;;
        esac
        exit 0
      fi
    '';
    executable = true;
  };
}
