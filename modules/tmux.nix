{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 2048000;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 200;
    terminal = "xterm-kitty";

    extraConfig = ''
      set -g default-terminal "xterm-kitty"
      set -ga terminal-overrides ",xterm*:RGB"
      set-window-option -g mode-keys vi

      # Renumber windows automatically
      set -g renumber-windows on

      # Copy/paste
      set -s copy-command 'wl-copy'

      # Window and pane splitting
      unbind %
      bind | split-window -h
      unbind '"'
      bind - split-window -v

      # Pane resizing
      bind -r C-m resize-pane -Z
      bind -r C-j resize-pane -D 5
      bind -r C-k resize-pane -U 5
      bind -r C-l resize-pane -R 5
      bind -r C-h resize-pane -L 5

      # Clear screen
      bind C-l send-key "C-l"

      # Split pane and keep path
      bind-key h split-window -h -c "#{pane_current_path}"
      bind-key v split-window -c "#{pane_current_path}"

      # Reload tmux config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Popups
      bind C-t display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "zsh"
      bind C-g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit"
    '';

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      vim-tmux-navigator
      yank
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "mocha"
          set -g @catppuccin_window_tabs_enabled "on"
          set -gF window-status-separator ""
          set -g @catppuccin_window_middle_separator ""
          set -g @catppuccin_host "off"
          set -g status-position top
          set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"
          set -g status-left ""
        '';
      }
      {
        plugin = sidebar;
        extraConfig = ''
          set -g @sidebar-tree-command 'ls -1'
          set -g @sidebar-tree 'e'
          set -g @sidebar-tree-focus 'e'
        '';
      }
    ];

  };
}
