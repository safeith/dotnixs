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
                       padding_left=8 \
                       padding_right=8 \
                       margin=8 \
                       y_offset=4 \
                       corner_radius=10 \
                       display=all \
                       color=0xdd${colors.base00}

      sketchybar --default icon.font="JetBrainsMono Nerd Font:Regular:20.0" \
                           icon.color=0xff${colors.base0C} \
                           label.font="JetBrainsMono Nerd Font:SemiBold:15.0" \
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
                           icon.color=0xff${colors.base0E} \
                           script="$PLUGIN_DIR/clock.sh"

      sketchybar --add item date right \
                 --set date update_freq=60 \
                           icon="󰃭" \
                           icon.color=0xff${colors.base0A} \
                           script="$PLUGIN_DIR/date.sh"

      sketchybar --add item keyboard right \
                 --set keyboard update_freq=1 \
                           icon="󰌌" \
                           icon.color=0xff${colors.base0C} \
                           script="$PLUGIN_DIR/keyboard.sh"

      sketchybar --add item network right \
                 --set network update_freq=5 \
                           icon="󰈀" \
                           label.padding_left=0 \
                           label.padding_right=0 \
                           icon.color=0xff${colors.base0B} \
                           script="$PLUGIN_DIR/network.sh"

      sketchybar --add item volume right \
                 --set volume script="$PLUGIN_DIR/volume.sh" \
                 --subscribe volume volume_change

      sketchybar --add item battery right \
                 --set battery update_freq=120 \
                           icon.font="JetBrainsMono Nerd Font:Regular:20.0" \
                           script="$PLUGIN_DIR/battery.sh" \
                 --subscribe battery system_woke power_source_change

      sketchybar --add event aerospace_workspace_change

      for sid in 1 2 3 4 5; do
        sketchybar --add item "space.$sid" left \
                   --subscribe "space.$sid" aerospace_workspace_change \
                   --set "space.$sid" \
                   icon="○" \
                   icon.font="JetBrainsMono Nerd Font:Bold:20.0" \
                   icon.padding_left=8 \
                   icon.padding_right=8 \
                   label.drawing=off \
                   background.drawing=off \
                   click_script="${pkgs.aerospace}/bin/aerospace workspace $sid" \
                   script="$PLUGIN_DIR/aerospacer.sh $sid"
      done

      sketchybar --add item separator_left1 left \
                 --set separator_left1 icon="|" \
                           icon.color=0xff${colors.base03} \
                           label.drawing=off \
                           padding_left=0 \
                           padding_right=0

      sketchybar --add item front_app left \
                 --set front_app script="$PLUGIN_DIR/front_app.sh" \
                           icon.color=0xff${colors.base0D} \
                           label.font="JetBrainsMono Nerd Font:Bold:15.0" \
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

  home.file.".config/sketchybar/plugins/cpu.sh" = {
    text = ''
      #!/bin/bash
      CPU_USAGE=$(top -l 2 -n 0 -F | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')
      sketchybar --set $NAME label="$CPU_USAGE%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/memory.sh" = {
    text = ''
      #!/bin/bash
      MEMORY_USED=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | sed 's/%//')
      if [ -z "$MEMORY_USED" ]; then
        MEMORY_USED=$(vm_stat | awk '/Pages active:/ {active=$3} /Pages wired down:/ {wired=$4} /Pages free:/ {free=$3} END {gsub(/\./, "", active); gsub(/\./, "", wired); gsub(/\./, "", free); printf "%.0f", ((active+wired)/(active+wired+free))*100}')
      fi
      sketchybar --set $NAME label="$MEMORY_USED%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/keyboard.sh" = {
    text = ''
      #!/bin/bash
      LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed -E 's/.*"KeyboardLayout Name" = "?([^"]*)"?;/\1/')

      case $LAYOUT in
        *Persian*|*Farsi*)
          DISPLAY="FA"
          ;;
        *)
          DISPLAY="EN"
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
          sketchybar --set $NAME icon="󰖩" icon.color=0xff${colors.base0B} label=""
        else
          sketchybar --set $NAME icon="󰖪" icon.color=0xff${colors.base08} label=""
        fi
      else
        sketchybar --set $NAME icon="󰖪" icon.color=0xff${colors.base08} label=""
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

      sketchybar --set $NAME icon="$ICON" icon.color=0xff${colors.base0B} label="$VOLUME%"
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

      sketchybar --set $NAME icon="$ICON" icon.color=0xff${colors.base09} label="$PERCENTAGE%"
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
        sketchybar --set $NAME icon="●" icon.color=0xff${colors.base0D}
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
