{ librime
, lua54Packages
, source-librime-charcode
, source-librime-lua
, source-librime-octagram
, source-librime-proto
, ...
}:
(librime.override {
  plugins = [
    (source-librime-charcode.src.overrideAttrs (old: {
      name = "librime-charcode";
    }))
    (source-librime-lua.src.overrideAttrs (old: {
      name = "librime-lua";
    }))
    (source-librime-octagram.src.overrideAttrs (old: {
      name = "librime-octagram";
    }))
    (source-librime-proto.src.overrideAttrs (old: {
      name = "librime-proto";
    }))
  ];
}).overrideAttrs
  (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ lua54Packages.lua ];

    meta = old.meta // {
      description = "Librime with plugins (librime-charcode, librime-lua, librime-octagram, librime-proto)";
    };
  })
