{ ghostty
, ...
}:
ghostty.overrideAttrs (old: {
  zigBuildFlags = old.zigBuildFlags ++ [ "-fsys=fontconfig" ];
})
