{ config, pkgs, ... }:

{
  # define my home
  home = {
    username = "duli";
    homeDirectory = "/home/duli";
    stateVersion = "23.11"; # change it before read release note.

    packages = with pkgs; [
      # command line tool
      bat btop eza fastfetch fd fzf ripgrep sshs zoxide

      # nix related
      nixd nixpkgs-fmt nix-output-monitor
    ];

    file = {

    };

    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  programs.home-manager.enable = true;

}
