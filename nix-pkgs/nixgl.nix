{ nixgl }:
let
  nvidiaVersion = "575.57.08";
in
nixgl.override {
  inherit nvidiaVersion;
}
