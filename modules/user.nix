{ lib, ... }:

let
  # Get user config path consistently
  userConfigPath = /. + builtins.getEnv "PWD" + "/user.nix";

  # Define the expected structure of user config with validation
  userConfigSchema = lib.types.submodule {
    options = {
      personalUsername = lib.mkOption {
        type = lib.types.str;
        description = "Username for personal/Linux systems";
        example = "john";
      };

      workUsername = lib.mkOption {
        type = lib.types.str;
        description = "Username for work/macOS systems";
        example = "john.doe";
      };

      personalEmail = lib.mkOption {
        type = lib.types.str;
        description = "Personal email address";
        example = "john@example.com";
      };

      workEmail = lib.mkOption {
        type = lib.types.str;
        description = "Work email address";
        example = "john.doe@company.com";
      };

      Name = lib.mkOption {
        type = lib.types.str;
        description = "Full name for Git commits and user description";
        example = "John Doe";
      };
    };
  };

  # Load and validate user config
  loadUserConfig =
    if builtins.pathExists userConfigPath then
      let
        rawUserConfig = import userConfigPath;

        # Basic validation - check that all required fields exist
        requiredFields = [ "personalUsername" "workUsername" "personalEmail" "workEmail" "Name" ];
        missingFields = lib.filter (field: !(rawUserConfig ? ${field})) requiredFields;

      in
      if missingFields == [ ] then
        rawUserConfig
      else
        builtins.throw ''
          user.nix is missing required fields: ${lib.concatStringsSep ", " missingFields}
            
          Please ensure your user.nix contains all required fields.
          See user.nix.example for the expected structure.
        ''
    else
      builtins.throw ''
        user.nix not found at ${toString userConfigPath}
        
        To fix this:
        1. Copy user.nix.example to user.nix
        2. Fill in your personal values
        3. The file is already gitignored for privacy
        
        Example:
        cp user.nix.example user.nix
        # Then edit user.nix with your values
      '';

in
{
  # Export the validated user config as a module option
  options.userConfig = lib.mkOption {
    type = userConfigSchema;
    default = loadUserConfig;
    description = "Validated user configuration loaded from user.nix";
  };

  # Also export user config path for any modules that might need it
  options.userConfigPath = lib.mkOption {
    type = lib.types.path;
    default = userConfigPath;
    description = "Path to the user.nix file";
    readOnly = true;
  };
}
