{ config, lib, pkgs, ... }:

{
  imports = [
    ../config/emacs.nix
  ];

  home = {
    packages = with pkgs; [
      # command line tool
      bat btop eza duf dust fastfetch fd fzf ripgrep sshs zoxide

      # nix related
      nixd nixpkgs-fmt nix-output-monitor
    ];

    file = {

    };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
}
