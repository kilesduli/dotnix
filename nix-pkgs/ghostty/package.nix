{ ghostty,
}:
ghostty.overrideAttrs (old: {
  zigBuildFlags = old.zigBuildFlags or "" + " -fsys=fontconfig";
})
