{ calibre
, source-calibre-do-not-translate
, lib
, python3Packages
, ...
}:
let
  calibre-do-not-translate = source-calibre-do-not-translate.src;
in
calibre.overrideAttrs (old: {
  postPatch = lib.optionalString (old ? postPatch) "" + ''
    echo "[=] Patch backend.py"
    cp -r ${calibre-do-not-translate} ./patch-script/
    chmod +w ./patch-script
    python ./patch-script/patch_backend.py --os unix src/calibre/db/backend.py ./patch-script/backend.py
    cp ./patch-script/backend.py src/calibre/db/backend.py
  '';

  buildInputs = old.buildInputs ++ [
    python3Packages.click
    python3Packages.sqlparse
  ];
})
