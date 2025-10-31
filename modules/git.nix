{ pkgs, lib, secretsPath, ... }:

let
  isWork = pkgs.stdenv.isDarwin;
  secrets = import secretsPath;

in {
  home.file.".gitignore" = lib.mkIf isWork {
    text = ''
      */tmp
      **/*tfstate*
      **/todo.md
      **/uv.lock
      **/.terraform*
      **/.venv
      **/.python-version
      **/pyproject.toml
      **/pyrightconfig.json
      **/PlatformMetadata
      **/globals.tf
      **/locals.tf
      **/AGENTS.md
    '';
  };

  programs.git = {
    enable = true;
    userName = "Hojjat";
    userEmail = if isWork then secrets.workEmail else secrets.personalEmail;

    signing = {
      signByDefault = true;
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
    };

    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.program = "${pkgs.openssh}/bin/ssh-keygen";

      commit.gpgsign = true;
      tag.gpgSign = true;

      push.autoSetupRemote = true;
      pull.rebase = true;

      core.sshCommand = "ssh -o IdentitiesOnly=yes";

      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        excludesFile = "~/.gitignore";
      };

      alias = {
        clean-branches = ''
          !git branch | grep -v "^master" | grep -v "^main" | xargs git branch -D'';
      };

      credential."https://github.com" = { helper = "!gh auth git-credential"; };
    };

    includes = lib.mkIf isWork [
      {
        condition = "gitdir:~/JeT/";
        contents = {
          user = {
            email = secrets.workEmail;
            name = "Hojjat";
          };
        };
      }
      {
        condition = "gitdir:~/HAM/";
        contents = {
          user = {
            email = secrets.personalEmail;
            name = "Hojjat";
          };
        };
      }
    ];
  };
}
