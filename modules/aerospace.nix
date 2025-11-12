{ config, pkgs, ... }:

{
  home.packages = [ pkgs.jankyborders ];

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
    inner.horizontal = 6
    inner.vertical = 6
    outer.left = 6
    outer.right = 6
    outer.bottom = 6
    outer.top = [
      { monitor."built-in" = 14 },
      { monitor."main" = 42 },
      42
    ]

    [workspace-to-monitor-force-assignment]
    1 = 'main'
    2 = 'main'
    3 = 'main'
    4 = 'main'
    5 = 'main'
    6 = 'HIDDENL'
    7 = 'HIDDENR'

    [[on-window-detected]]
    if.workspace = '6'
    run = 'move-node-to-workspace 5'

    [[on-window-detected]]
    if.workspace = '7'
    run = 'move-node-to-workspace 5'

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

    alt-shift-1 = ['move-node-to-workspace 1', 'workspace 1', 'balance-sizes']
    alt-shift-2 = ['move-node-to-workspace 2', 'workspace 2', 'balance-sizes']
    alt-shift-3 = ['move-node-to-workspace 3', 'workspace 3', 'balance-sizes']
    alt-shift-4 = ['move-node-to-workspace 4', 'workspace 4', 'balance-sizes']
    alt-shift-5 = ['move-node-to-workspace 5', 'workspace 5', 'balance-sizes']

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

}
