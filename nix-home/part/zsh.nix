{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases =
      let
        user- = command: "systemctl --user ${command}";
      in
      {
        user-start = user- "start";
        user-restart = user- "restart";
        user-status = user- "status";
        user-stop = user- "stop";
        fars = ''curl -F "c=@-" "http://fars.ee/"'';
        ls = "eza --time-style iso -m --group-directories-first";
        ll = "eza --time-style iso --icons -l -m --group-directories-first";
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
      "git"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "fzf-tab"
    ];
    custom = "$HOME/.oh-my-zsh/custom";
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
