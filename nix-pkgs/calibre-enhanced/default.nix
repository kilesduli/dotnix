{ calibre
, lib
, ...
}:
calibre.overrideAttrs (old: {
  patches = old.patches ++ [
    ./0001-feat-avoid-latinization-of-paths-in-certain-function.patch
  ];
})
