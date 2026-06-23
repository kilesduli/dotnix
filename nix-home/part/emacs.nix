{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master-lucid-w_igc-wo_cairo-wo_native-comp;
in
{
  # the programs.emacs has warp that cause no include dir
  home.packages = [ emacs ];

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      Documentation = "info:emacs man:emacs(1) https://gnu.org/software/emacs/";

      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];

      # nix ext config
      X-RestartIfChanged = false;
    };

    Service = {
      Type = "notify";

      # Runtimeshell wrap nix things. See home-manager.
      ExecStart = ''${pkgs.runtimeShell} -l -c "${emacs}/emacs --fg-daemon'';

      ExecStop = ''${emacs}/bin/emacsclient --eval "(kill-emacs)" '';

      # After received SIGTERM, emacs exit with 15, which is killsignal value of systemd.
      # See Home-manager here.
      SuccessExitStatus = 15;

      TimeoutStopSec = "10s";

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [
        "graphical-session.target"
      ];
    };
  };
}
