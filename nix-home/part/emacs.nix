{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master-lucid-wo_igc-wo_cairo-wo_native-comp;
in
{
  # the programs.emacs has warp that cause no include dir
  home.packages = [ emacs ];

  services.emacs = {
    enable = true;
    package = emacs;
    # seems I don't use daemon in tty 

    startWithUserSession = "graphical";
  };
}
