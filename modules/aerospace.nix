{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.jankyborders
  ];

  home.file.".aerospace.toml".text = ''
    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    default-root-container-layout = 'tiles'
    default-root-container-orientation = 'auto'

    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
    on-focus-changed = "move-mouse window-lazy-center"

    after-startup-command = []
    after-login-command = []

    exec-on-workspace-change = ['/bin/bash', '-c',
      '${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
    ]

    [gaps]
    inner.horizontal = 8
    inner.vertical = 8
    outer.left = 8
    outer.bottom = 8
    outer.top = [
      { monitor."built-in" = 12 },
      { monitor."main" = 44 },
      44
    ]
    outer.right = 8



    [workspace-to-monitor-force-assignment]
    6 = 'HIDDEN'

    [[on-window-detected]]
    if.app-id = 'net.kovidgoyal.kitty'
    run = ['move-node-to-workspace 3']

    [[on-window-detected]]
    if.app-id = 'com.spotify.client'
    run = ['move-node-to-workspace 5']

    [[on-window-detected]]
    if.app-id = 'com.brave.Browser'
    run = ['move-node-to-workspace 2']

    [mode.main.binding]
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    alt-r = 'mode resize'

    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'

    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'

    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'

    alt-f = 'fullscreen'

    alt-shift-space = 'layout floating tiling'

    alt-shift-b = 'balance-sizes'

    alt-shift-r = 'reload-config'

    [mode.resize.binding]
    h = 'resize width -50'
    j = 'resize height +50'
    k = 'resize height -50'
    l = 'resize width +50'
    enter = 'mode main'
    esc = 'mode main'
  '';



  launchd.agents.jankyborders = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.jankyborders}/bin/borders"
        "active_color=0xff${config.lib.stylix.colors.base0D}"
        "inactive_color=0xff45475a"
        "width=5.0"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Interactive";
    };
  };

  launchd.agents.aerospace-webapp-organizer = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
          export PATH="/opt/homebrew/bin:$PATH"
          while true; do
            sleep 5
            aerospace list-windows --workspace 2 --format '%{window-id}|%{window-title}' 2>/dev/null | while IFS='|' read -r win_id title; do
              title_lower=$(echo "$title" | tr '[:upper:]' '[:lower:]')
              case "$title_lower" in
                *gmail*) aerospace move-node-to-workspace --window-id "$win_id" 1 2>/dev/null ;;
                *whatsapp*) aerospace move-node-to-workspace --window-id "$win_id" 4 2>/dev/null ;;
                *telegram*) aerospace move-node-to-workspace --window-id "$win_id" 4 2>/dev/null ;;
                *youtube*) aerospace move-node-to-workspace --window-id "$win_id" 5 2>/dev/null ;;
                *soundcloud*) aerospace move-node-to-workspace --window-id "$win_id" 5 2>/dev/null ;;
              esac
            done
          done
        ''
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
