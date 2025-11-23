{ config, pkgs, ... }:

{
  imports = [
    ./part/emacs.nix
    ./part/zsh.nix
    ./config-duli.nix
  ];

  # define my home
  home = {
    username = "duli";
    homeDirectory = "/home/duli";
    stateVersion = "25.05"; # change it before read release note.
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "suggest";
}
