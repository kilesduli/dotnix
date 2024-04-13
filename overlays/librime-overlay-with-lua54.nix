final: prev:
{
  librime-with-plugins = prev.lantianCustomized.librime-with-plugins.overrideAttrs (
    old:{
      buildInputs = (prev.lib.lists.remove prev.pkgs.luajit old.buildInputs) ++ [ prev.pkgs.lua54Packages.lua ];
    }
  );
}
