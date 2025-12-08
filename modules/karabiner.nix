{ lib, ... }:

{
  home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
    global = {
      ask_for_confirmation_before_quitting = false;
      show_in_menu_bar = false;
    };
    profiles = [
      {
        name = "main";
        selected = true;
        complex_modifications = {
          rules = [
            {
              description = "Lockscreen via Option+L";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "l";
                    modifiers = {
                      mandatory = [ "left_option" ];
                    };
                  };
                  to = [
                    {
                      key_code = "q";
                      modifiers = [ "left_command" "left_control" ];
                    }
                  ];
                }
              ];
            }
            {
              description = "Left Ctrl to Left Command (except in kitty)";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "left_control";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to = [
                    {
                      key_code = "left_command";
                    }
                  ];
                  conditions = [
                    {
                      type = "frontmost_application_unless";
                      bundle_identifiers = [
                        "^net\\.kovidgoyal\\.kitty$"
                      ];
                    }
                  ];
                }
              ];
            }
            {
              description = "Right Ctrl to Right Command (except in kitty)";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "right_control";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to = [
                    {
                      key_code = "right_command";
                    }
                  ];
                  conditions = [
                    {
                      type = "frontmost_application_unless";
                      bundle_identifiers = [
                        "^net\\.kovidgoyal\\.kitty$"
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
        devices = [
          {
            identifiers = {
              is_keyboard = true;
            };
            simple_modifications = [
              {
                from = {
                  apple_vendor_top_case_key_code = "keyboard_fn";
                };
                to = [
                  { key_code = "left_control"; }
                ];
              }
              {
                from = {
                  key_code = "grave_accent_and_tilde";
                };
                to = [
                  { key_code = "left_shift"; }
                ];
              }
              {
                from = {
                  key_code = "left_command";
                };
                to = [
                  { key_code = "left_option"; }
                ];
              }
              {
                from = {
                  key_code = "left_option";
                };
                to = [
                  { key_code = "left_command"; }
                ];
              }
              {
                from = {
                  key_code = "non_us_backslash";
                };
                to = [
                  { key_code = "grave_accent_and_tilde"; }
                ];
              }
            ];
          }
        ];
        simple_modifications = [
          {
            from = {
              key_code = "caps_lock";
            };
            to = [
              { key_code = "escape"; }
            ];
          }
        ];
        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };
}
