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
  vendorHash = "sha256-uuvlu5yocqnDh6OO5a4Ngp5SahqURc/14fcg1Kr9sec=";

  patches = [ ];

  postPatch = (old.postPatch or "") + ''
    substituteInPlace src/preprocess/preprocess.go --replace-warn \
    "	if version != \"Dev\" {" \
    "	if version != \"${version}\" {"
  '';
})
