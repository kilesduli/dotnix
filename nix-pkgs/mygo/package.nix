{ go }:
go.overrideAttrs ( old: {
  patches = (old.patches or []) ++ [
    ./0001-let-unused-import-variable-as-warning.patch
    ./0002-rename-go-to-mygo.patch
  ];
})
