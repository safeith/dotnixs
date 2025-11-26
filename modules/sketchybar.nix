{ config, pkgs, ... }:

let colors = config.lib.stylix.colors;
in {
  home.packages = with pkgs; [ sketchybar sketchybar-app-font ];

  home.file.".config/sketchybar/sketchybarrc" = {
    text = ''
      #!/bin/bash

      PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

      sketchybar --bar height=32 \
                       blur_radius=50 \
                       position=top \
                       sticky=off \
                       padding_left=4 \
                       padding_right=4 \
                       margin=4 \
                       y_offset=4 \
                       corner_radius=10 \
                       display=all \
                       color=0xdd${colors.base00}

      sketchybar --default icon.font="JetBrainsMono Nerd Font:Regular:16.0" \
                           icon.color=0xff${colors.base05} \
                           label.font="JetBrainsMono Nerd Font:SemiBold:13.0" \
                           label.color=0xff${colors.base05} \
                           padding_left=2 \
                           padding_right=2 \
                           label.padding_left=2 \
                           label.padding_right=4 \
                           icon.padding_left=4 \
                           icon.padding_right=2

      sketchybar --add item clock right \
                 --set clock update_freq=1 \
                           icon="󱑂" \
                           script="$PLUGIN_DIR/clock.sh"

      sketchybar --add item date right \
                 --set date update_freq=60 \
                           icon="󰃭" \
                           script="$PLUGIN_DIR/date.sh"

      sketchybar --add item keyboard right \
                 --set keyboard update_freq=1 \
                           icon="󰌌" \
                           script="$PLUGIN_DIR/keyboard.sh"

      sketchybar --add item network right \
                 --set network update_freq=5 \
                           icon="󰈀" \
                           label.padding_left=0 \
                           label.padding_right=0 \
                           script="$PLUGIN_DIR/network.sh"

      sketchybar --add item volume right \
                 --set volume script="$PLUGIN_DIR/volume.sh" \
                 --subscribe volume volume_change

      sketchybar --add item battery right \
                 --set battery update_freq=120 \
                           script="$PLUGIN_DIR/battery.sh" \
                 --subscribe battery system_woke power_source_change

      sketchybar --add event aerospace_workspace_change

      for sid in 1 2 3 4 5; do
        sketchybar --add item "space.$sid" left \
                   --subscribe "space.$sid" aerospace_workspace_change \
                   --set "space.$sid" \
                   icon="○" \
                   icon.padding_left=0 \
                   icon.padding_right=12 \
                   label.drawing=off \
                   background.drawing=off \
                   click_script="${pkgs.aerospace}/bin/aerospace workspace $sid" \
                   script="$PLUGIN_DIR/aerospacer.sh $sid"
      done

      sketchybar --add item front_app left \
                 --set front_app padding_left=0 \
                           script="$PLUGIN_DIR/front_app.sh" \
                 --subscribe front_app front_app_switched aerospace_workspace_change

      sketchybar --update
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/clock.sh" = {
    text = ''
      #!/bin/bash
      sketchybar --set $NAME label="$(date '+%H:%M:%S')"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/date.sh" = {
    text = ''
      #!/bin/bash
      sketchybar --set $NAME label="$(date '+%a %Y-%m-%d')"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/keyboard.sh" = {
    text = ''
      #!/bin/bash
      LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed -E 's/.*"KeyboardLayout Name" = "?([^"]*)"?;/\1/')

      case $LAYOUT in
        *Persian*|*Farsi*)
          DISPLAY="ir"
          ;;
        *)
          DISPLAY="en"
          ;;
      esac

      sketchybar --set $NAME label="$DISPLAY"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/network.sh" = {
    text = ''
      #!/bin/bash
      INTERFACE=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')
      if [ -n "$INTERFACE" ]; then
        IP=$(ipconfig getifaddr "$INTERFACE" 2>/dev/null)
        if [ -n "$IP" ]; then
          sketchybar --set $NAME icon="󰖩" label=""
        else
          sketchybar --set $NAME icon="󰖪" label=""
        fi
      else
        sketchybar --set $NAME icon="󰖪" label=""
      fi
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/volume.sh" = {
    text = ''
      #!/bin/bash
      VOLUME=$(osascript -e "output volume of (get volume settings)")
      MUTED=$(osascript -e "output muted of (get volume settings)")

      if [ "$MUTED" = "true" ] || [ "$VOLUME" -eq 0 ]; then
        ICON=""
      elif [ "$VOLUME" -lt 33 ]; then
        ICON=""
      elif [ "$VOLUME" -lt 67 ]; then
        ICON=""
      else
        ICON=""
      fi

      sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/battery.sh" = {
    text = ''
      #!/bin/bash
      PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
      CHARGING=$(pmset -g batt | grep 'AC Power')

      if [ $PERCENTAGE = "" ]; then
        exit 0
      fi

      if [[ $CHARGING != "" ]]; then
        ICON=""
      else
        if [ $PERCENTAGE -gt 80 ]; then
          ICON=""
        elif [ $PERCENTAGE -gt 60 ]; then
          ICON=""
        elif [ $PERCENTAGE -gt 40 ]; then
          ICON=""
        elif [ $PERCENTAGE -gt 20 ]; then
          ICON=""
        else
          ICON=""
        fi
      fi

      sketchybar --set $NAME icon="$ICON" label="$PERCENTAGE%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/front_app.sh" = {
    text = ''
      #!/bin/bash
      if [ "$SENDER" = "front_app_switched" ]; then
        sketchybar --set $NAME label="$INFO"
      else
        CURRENT_APP=$(${pkgs.aerospace}/bin/aerospace list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)
        sketchybar --set $NAME label="$CURRENT_APP"
      fi
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/aerospacer.sh" = {
    text = ''
      #!/bin/bash
      if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set $NAME icon="●" icon.color=0xff${colors.base0B}
      else
        sketchybar --set $NAME icon="●" icon.color=0xff${colors.base03}
      fi
    '';
    executable = true;
  };

  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Interactive";
      EnvironmentVariables = {
        PATH =
          "${pkgs.sketchybar}/bin:${pkgs.bash}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
