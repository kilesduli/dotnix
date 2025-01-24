{ nvfetcher
,
}:
nvfetcher.overrideAttrs (old: {
  patches = old.patches or [ ] ++ [ ./0001-fix-do-not-generate-deepClone-option.patch ];
})
