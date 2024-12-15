{ calibre
, lib
, ccacheStdenv
, ...
}:
(calibre.override { stdenv = ccacheStdenv; }).overrideAttrs (old: {
  patches = old.patches ++ [
    ./0001-feat-avoid-latinization-of-paths-in-certain-function.patch
  ];
})
