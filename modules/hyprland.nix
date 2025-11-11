{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      monitor = [
        "eDP-1,1920x1080@60,0x0,1.25"
        "DP-2,3440x1440@60,auto,1.25"
        ",preferred,auto,1.25"
      ];

      bindl = [
        '',switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1,disable"''
        ''
          ,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1.25"
        ''
      ];

      env = [
        "XCURSOR_SIZE,${toString config.stylix.cursor.size}"
        "XCURSOR_THEME,${config.stylix.cursor.name}"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_STYLE_OVERRIDE,kvantum"
      ];

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
        "gsettings set org.gnome.desktop.interface cursor-theme '${config.stylix.cursor.name}'"
        "gsettings set org.gnome.desktop.interface cursor-size ${
          toString config.stylix.cursor.size
        }"

        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        "if [ $(hyprctl monitors -j | jq 'length') -gt 1 ]; then hyprctl keyword monitor 'eDP-1,disable'; fi"
      ];

      input = {
        kb_layout = "us,ir";
        kb_options = "caps:escape,altwin:ctrl_win,grp:alt_space_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgb(${config.lib.stylix.colors.base0D})";
        "col.inactive_border" = "rgb(45475a)";
        layout = "dwindle";
        allow_tearing = false;
        no_border_on_floating = false;
      };

      decoration = {
        rounding = 10;
        blur = { enabled = false; };
        shadow = { enabled = false; };
        active_opacity = 0.98;
        inactive_opacity = 0.96;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      animations = {
        enabled = true;
        bezier = "ease,0.4,0.0,0.2,1";
        animation = [
          "windows,1,3,ease"
          "windowsOut,1,3,ease,popin 80%"
          "border,1,5,default"
          "fade,1,3,ease"
          "workspaces,1,3,ease"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = { workspace_swipe = true; };

      xwayland = { force_zero_scaling = true; };

      "$mod" = "ALT";

      bind = [
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        "$mod, f, fullscreen, 0"
        "$mod, m, fullscreen, 1"
        "$mod SHIFT, space, togglefloating"
        "$mod SHIFT, b, pseudo"
        "$mod, slash, togglesplit"

        "$mod, k, exec, kitty"
        "$mod, b, exec, brave"
        "CTRL, space, exec, rofi -show drun"

        '', Print, exec, grim -g "$(slurp)" - | swappy -f -''
        "SHIFT, Print, exec, grim - | swappy -f -"
        ''CTRL ALT, p, exec, grim -g "$(slurp)" - | swappy -f -''
        "$mod, x, exec, hyprpicker -a"
        "$mod, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mod SHIFT, v, exec, cliphist list | rofi -dmenu | cliphist delete"
        "$mod SHIFT, c, exec, cliphist wipe && notify-send 'Clipboard' 'History cleared'"
        "CTRL, q, exec, hyprlock"
        "$mod, p, exec, ~/.local/bin/rofi-powermenu"

        "$mod SHIFT, F1, exec, powerprofilesctl set power-saver && notify-send 'Power Profile' 'Power Saver'"
        "$mod SHIFT, F2, exec, powerprofilesctl set balanced && notify-send 'Power Profile' 'Balanced'"
        "$mod SHIFT, F3, exec, powerprofilesctl set performance && notify-send 'Power Profile' 'Performance'"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioStop, exec, playerctl stop"

        "$mod, q, killactive"
        "$mod SHIFT, r, exec, hyprctl reload"
        "$mod SHIFT, e, exit"

        "$mod, r, submap, resize"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 5%+"
        "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
      ];
    };

    extraConfig = ''
      submap = resize
      binde = , h, resizeactive, -50 0
      binde = , l, resizeactive, 50 0
      binde = , k, resizeactive, 0 -50
      binde = , j, resizeactive, 0 50
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset
    '';
  };
}
