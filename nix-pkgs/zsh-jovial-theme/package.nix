{ source-zsh-jovial-theme, stdenv, lib, ... }:

stdenv.mkDerivation {
  pname = "zsh-jovial-theme";
  version = "0-unstable-${source-zsh-jovial-theme.date}";
  inherit (source-zsh-jovial-theme) src;

  installPhase = ''
    install -D jovial.zsh-theme $out/share/zsh-jovial-theme/jovial.zsh-theme
  '';

  meta = with lib; {
    description = "zsh jovial theme";
    homepage = "https://github.com/zthxxx/jovial";
    license = licenses.mit;
  };
}
