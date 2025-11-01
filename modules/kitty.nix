{ config, pkgs, lib, ... }:

let isWork = pkgs.stdenv.isDarwin;
in {
  programs.kitty = {
    enable = true;
    package = if isWork then pkgs.emptyDirectory else pkgs.kitty;
    shellIntegration.enableZshIntegration = true;

    keybindings = {
      "ctrl+shift+z" = "toggle_layout stack";
      "ctrl+shift+t" = "launch --type=overlay tmux new-window";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };

    settings = {
      notify_on_cmd_finish = "never";
      enable_audio_bell = "no";
      cursor_shape = "underline";
      mouse_hide_wait = 3.0;

      # Font
      font_size = if pkgs.stdenv.isDarwin then 13 else 11;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      modify_font = if pkgs.stdenv.isDarwin then "cell_height 150%" else "cell_height 125%";

      # Layout
      enabled_layouts = "Tall,*";

      # Transparency
      background_opacity = lib.mkForce "0.98";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template =
        "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };

    extraConfig = lib.optionalString isWork ''
      # SSH agent
      shell_integration enabled
    '';
  };
}
