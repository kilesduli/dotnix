{ config, lib, pkgs, ... }:

{
  systemd.user.services.cnws = {
    Unit = {
      Description = "chinese-word-segmentation jieba";
    };

    Service = {
      Type = "simple";

      ExecStart = ''${pkgs.cnws}/bin/cnws-server-jieba'';

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

  };
}
