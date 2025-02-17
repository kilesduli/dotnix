{ source-spicetify-cli
, spicetify-cli
, ...
}:
let
  removePrefixv = version: with builtins; substring 1 (stringLength version) version;
in
spicetify-cli.overrideAttrs (old: {
  version = removePrefixv source-spicetify-cli.version + "-unstable";
  inherit (source-spicetify-cli) src;
  vendorHash = "sha256-3U/qV81UXS/Xh3K6OnMUyRKeMSBQUHLP64EOQl6TfMY=";
})
