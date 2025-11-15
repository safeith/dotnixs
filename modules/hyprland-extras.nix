{ config, pkgs, lib, ... }:

let colors = config.lib.stylix.colors;
in {
  home.packages = with pkgs; [
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    hyprpicker
    swww
    pavucontrol
    blueman
    networkmanagerapplet
    polkit_gnome
    playerctl
    brightnessctl

    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler
  ];

  home.file.".local/bin/rofi-powermenu" = {
    text = ''
      #!/usr/bin/env bash

      chosen=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i -p "Power Menu" -theme-str 'window { width: 400px; } listview { lines: 5; }')

      case "$chosen" in
        "Lock") hyprlock ;;
        "Logout") hyprctl dispatch exit ;;
        "Suspend") systemctl suspend ;;
        "Reboot") systemctl reboot ;;
        "Shutdown") systemctl poweroff ;;
      esac
    '';
    executable = true;
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = lib.mkForce "#${colors.base00}";
      text-color = lib.mkForce "#${colors.base05}";
      border-color = lib.mkForce "#${colors.base0B}";
      border-radius = lib.mkForce 10;
      border-size = lib.mkForce 2;
      default-timeout = lib.mkForce 5000;
      layer = lib.mkForce "overlay";
      font = lib.mkForce "JetBrainsMono Nerd Font 12";
      padding = lib.mkForce "10";
      margin = lib.mkForce "10";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = lib.mkForce 0;
        hide_cursor = lib.mkForce true;
        ignore_empty_input = lib.mkForce true;
      };

      background = lib.mkForce [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];

      input-field = lib.mkForce [{
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(${colors.base05})";
        inner_color = "rgb(${colors.base00})";
        outer_color = "rgb(${colors.base0B})";
        outline_thickness = 2;
        placeholder_text =
          "<span foreground='##${colors.base05}'>Password...</span>";
        shadow_passes = 2;
      }];

      label = lib.mkForce [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big>$(date +"%H:%M")</big></b>"'';
          color = "rgb(${colors.base05})";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text =
            ''cmd[update:18000000] echo "<b>$(date +"%A, %-d %B %Y")</b>"'';
          color = "rgb(${colors.base05})";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<b>$(layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'); case $layout in *English*) echo "EN";; *Persian*) echo "FA";; *) echo "  $layout";; esac)</b>"'';
          color = "rgb(${colors.base05})";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=screenshot-%Y%m%d-%H%M%S.png
    show_panel=true
    line_size=5
    text_size=20
    text_font=JetBrainsMono Nerd Font
  '';

  services.blueman-applet.enable = true;
}
