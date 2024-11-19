{ config, lib, pkgs, ... }:

let
  # we wanna system side environment works fine.
  zsh-symbolic = pkgs.runCommand "zsh-symlink" { } ''
    mkdir -p $out/bin
    ln -s /usr/bin/zsh $out/bin/zsh
  '';

  linkPlugin = pkg: name:
    { name = name; path = "${pkg}/share/${name}"; };

  linkPluginWithFix = pkg: name:
    let
      fixed = pkgs.symlinkJoin {
        inherit name;
        paths = [ pkg ];
        postBuild = ''
          install -D $out/share/${name}/${name}.zsh \
          $out/share/${name}/${name}.plugin.zsh
        '';
      };
    in
    { name = name; path = "${fixed}/share/${name}"; };

  mkLinkFarmEntry = name: dirs:
    let
      entry = pkgs.linkFarm "${name}" dirs;
    in
    { inherit name; path = "${entry}"; };


  oh-my-zsh-custom = pkgs.linkFarm "oh-my-zsh-custom" [
    (mkLinkFarmEntry "plugins" [
      (linkPluginWithFix pkgs.zsh-syntax-highlighting "zsh-syntax-highlighting")
      (linkPluginWithFix pkgs.zsh-autosuggestions "zsh-autosuggestions")
      (linkPlugin pkgs.zsh-fzf-tab "fzf-tab")
    ])
    (mkLinkFarmEntry "themes" [
      { name = "jovial.zsh-theme"; path = "${pkgs.zsh-jovial-theme}/share/zsh-jovial-theme/jovial.zsh-theme"; }
    ])
  ];

in
{
  programs.zsh = {
    enable = true;
    package = zsh-symbolic;
    shellAliases =
      let
        user- = command: "systemctl --user ${command}";
      in
      {
        user-start = user- "start";
        user-restart = user- "restart";
        user-status = user- "status";
        user-stop = user- "stop";
        flatpak-user = "flatpak --user";
        fars = ''curl -F "c=@-" "http://fars.ee/"'';
        ls = "eza --time-style iso -m --group-directories-first";
        ll = "eza --time-style iso -m --group-directories-first --icons -al";
        rsync-copy = "rsync -avz --progress -h";
        rsync-move = "rsync -avz --progress -h --remove-source-files";
        rsync-update = "rsync -avzu --progress -h";
        rsync-synchronize = "rsync -avzu --delete --progress -h";
      };
    initExtra = ''
      ex ()
        {
          if [ -f $1 ] ; then
            case $1 in
              *.tar.bz2)   tar xjf $1   ;;
              *.tar.gz)    tar xzf $1   ;;
              *.bz2)       bunzip2 $1   ;;
              *.rar)       unrar x $1   ;;
              *.gz)        gunzip $1    ;;
              *.tar)       tar xf $1    ;;
              *.tbz2)      tar xjf $1   ;;
              *.tgz)       tar xzf $1   ;;
              *.zip)       unzip $1     ;;
              *.Z)         uncompress $1;;
              *.7z)        7z x $1      ;;
              *.deb)       ar x $1      ;;
              *.tar.xz)    tar xf $1    ;;
              *.tar.zst)   unzstd $1    ;;
              *)           echo "'$1' cannot be extracted via ex()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }
    '';
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "jovial";
    plugins = [
      "bun" # help export
      "rust" # help export
      "volta" # help export
      "tailscale" # help export
#      "go" # with aliases
#      "yarn" #with aliases
#      "sdk"
#      "pip" # with offcial
#      "ssh"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "fzf-tab"
    ];
    custom = "${oh-my-zsh-custom}";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
    };
    sessionPath = [

    ];
  };
}
