{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.jankyborders
  ];

  home.file.".aerospace.toml".text = ''
    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

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
    5 = 'HIDDEN'

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

    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'

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
