{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master-igc;
in
{
  # the programs.emacs has warp that cause no include dir
  home.packages = [ emacs ];

  services.emacs = {
    enable = true;
    package = emacs;
  };
}
