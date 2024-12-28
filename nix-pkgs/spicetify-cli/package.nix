{ source-spicetify-cli
, spicetify-cli
, ...
}:
spicetify-cli.overrideAttrs (old: {
  version = "2.38.7-unstable";
  inherit (source-spicetify-cli) src;
  vendorHash = "sha256-a6lAVBUoSTqHnAKKvW+egmtupsuy0uB/XGtBaljju1I=";
})
