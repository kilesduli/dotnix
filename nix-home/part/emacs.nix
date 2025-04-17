{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master-lucid-with-igc-without-native-comp;
in
{
  # the programs.emacs has warp that cause no include dir
  home.packages = [ emacs ];

  services.emacs = {
    enable = true;
    package = emacs;
  };
}
