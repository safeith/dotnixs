{ config, pkgs, lib, ... }:

let colors = config.lib.stylix.colors;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        margin-left = 4;
        margin-right = 4;
        margin-top = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "hyprland/language"
          "idle_inhibitor"
          "custom/power-profile"
          "battery"
          "pulseaudio"
          "custom/date"
          "clock"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "●";
            active = "●";
          };
          all-outputs = false;
          show-special = false;
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        "hyprland/window" = { separate-outputs = false; };

        pulseaudio = {
          format = "<span size='large'>{icon}</span> {volume}%";
          format-muted = "<span size='large'>󰖁</span> {volume}%";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
        };

        battery = {
          format = "<span size='large'>{icon}</span> {capacity}%";
          format-charging = "<span size='large'></span> {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        clock = { format = "<span size='large'>󱑂</span> {:%H:%M:%S}"; };

        "custom/date" = {
          format = "<span size='large'>󰃭</span> {}";
          exec = "date '+%a %Y-%m-%d'";
          interval = 60;
        };

        "custom/power-profile" = {
          format = "{icon}";
          format-icons = {
            power-saver = "<span size='large'>󰳗</span>";
            balanced = "<span size='large'>󰆚</span>";
            performance = "<span size='large'>󰤇</span>";
          };
          exec = ''
            profile=$(powerprofilesctl get)
            icon=$([ "$profile" = "power-saver" ] && echo "" || [ "$profile" = "performance" ] && echo "" || echo "")
            echo "{\"text\":\"$profile\",\"tooltip\":\"Power Profile: $profile\",\"class\":\"$profile\",\"alt\":\"$profile\"}"
          '';
          return-type = "json";
          interval = 5;
          on-click = ''
            current=$(powerprofilesctl get)
            if [ "$current" = "power-saver" ]; then
              powerprofilesctl set balanced
            elif [ "$current" = "balanced" ]; then
              powerprofilesctl set performance
            else
              powerprofilesctl set power-saver
            fi
          '';
        };

        "custom/power" = {
          format = "<span size='large'>⏻</span>";
          on-click = "~/.local/bin/rofi-powermenu";
          tooltip = false;
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        idle_inhibitor = {
          format = "<span size='large'>{icon}</span>";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
          tooltip-format-activated = "Idle inhibitor active";
          tooltip-format-deactivated = "Idle inhibitor inactive";
        };

        "hyprland/language" = {
          format = "<span size='large'></span> {}";
          format-en = "us";
          format-fa = "ir";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 15px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #${colors.base00};
        color: #${colors.base05};
        padding: 0 8px;
        border-radius: 10px;
      }

      #workspaces {
        margin: 0;
        padding: 0;
      }

      #workspaces button {
        color: #${colors.base03};
        background: transparent;
        border: none;
        padding-left: 8px;
        padding-right: 8px;
        font-size: 24px;
        font-weight: normal;
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        color: #${colors.base0D};
        background: transparent;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.1);
        color: #${colors.base0D};
      }

      #window {
        color: #${colors.base05};
        font-weight: bold;
        padding-left: 8px;
        padding-right: 8px;
        margin-left: 8px;
        background: transparent;
      }

      /* Default module styling - all modules except powermenu */
      #clock,
      #custom-date,
      #custom-power-profile,
      #pulseaudio,
      #battery,
      #tray,
      #idle_inhibitor,
      #language,
      #custom-power {
        color: #${colors.base05};
        padding-left: 6px;
        padding-right: 6px;
        margin-left: 0px;
        margin-right: 0px;
        background: transparent;
      }

      /* Module-specific overrides */
      #custom-power {
        color: #${colors.base08};
        margin-right: 8px;
      }

      #idle_inhibitor,
      #custom-power-profile {
        margin-right: 4px;
      }

      /* Battery state colors */
      #battery.warning {
        color: #${colors.base0A};
      }

      #battery.critical {
        color: #${colors.base08};
      }
    '';
  };

  stylix.targets.waybar.enable = false;

}
