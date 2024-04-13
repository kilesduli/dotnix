{ config, pkgs, ... }:

{
  imports = [
    ./config-duli.nix
  ];

  # define my home
  home = {
    username = "duli";
    homeDirectory = "/home/duli";
    stateVersion = "23.11"; # change it before read release note.
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  programs.home-manager.enable = true;
}
