{ source-spicetify-cli
, spicetify-cli
, ...
}:
let
  removePrefixv = version: with builtins; substring 1 (stringLength version) version;
in
spicetify-cli.overrideAttrs (old: rec {
  version = removePrefixv source-spicetify-cli.version + "-unstable";
  inherit (source-spicetify-cli) src;
  vendorHash = "sha256-7Dk4tTyVgnNgDECYj24Uy4xavWkVVxWE8uZlkKsFobI=";

  patches = [ ];

  postPatch = (old.postPatch or "") + ''
    substituteInPlace src/preprocess/preprocess.go --replace-warn \
    "	if version != \"Dev\" {" \
    "	if version != \"${version}\" {"
  '';
})
