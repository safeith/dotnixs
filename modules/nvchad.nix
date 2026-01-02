{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.nix4nvchad.homeManagerModule ];

  programs.nvchad = {
    enable = true;
    backup = false;
    hm-activation = true;

    extraPackages = with pkgs; [
      actionlint
      fixjson
      gofumpt
      goimports-reviser
      golines
      gopls
      gotools
      lua-language-server
      pyright
      rust-analyzer
      rustfmt
      stylua
      terraform-ls
      tflint
      yaml-language-server
      yarn
      (python3.withPackages (ps: with ps; [ black mypy isort ]))
    ];
  };
}
