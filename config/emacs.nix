{ self, config, lib, pkgs, ... }:

let
  emacs = pkgs.emacs-git;
in
{
  programs.emacs = {
    enable = true;
    package = emacs;
    extraPackages = epkgs: [
      (epkgs.melpaPackages.rime.overrideAttrs (old: {
        buildInputs = (lib.lists.remove pkgs.librime old.buildInputs) ++ [ pkgs.librime-with-plugins ];
      }))
    ];
  };

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
}
