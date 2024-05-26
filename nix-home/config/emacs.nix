{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-master;
in
{
  home.packages = [ emacs ];

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      Documentation =
        "info:emacs man:emacs(1) https://gnu.org/software/emacs/";

      # Avoid killing the Emacs session, which may be full of
      # unsaved buffers.
      X-RestartIfChanged = false;
    };

    Service = {
      Type = "forking";
      ExecStart = ''
        ${emacs}/bin/emacs --daemon
      '';
      ExecStartPost = ''
        ${emacs}/bin/emacsclient -c --eval "(delete-frame)"
      '';
      ExecStop = ''
        ${emacs}/bin/emacsclient --no-wait --eval "(progn (setq kill-emacs-hook nil) (kill-emacs))"
      '';
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.file.".emacs.d" = {
    source = self.inputs.doom-emacs.outPath;
    recursive = true;
  };
}
