{ source-emacs-lsp-booster, rustPlatform, lib, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source-emacs-lsp-booster) src;

  pname = "emacs-lsp-booster";
  version = "0.2.1-unstable";

  cargoHash = "sha256-7lIceMT2hJplHU2VIN1O8IiGE6+DxO4/uM8pYS/qvlE=";

  # The tests contain what are essentially benchmarks—it seems prudent not to
  # stress our users' computers in that way every time they build the package.
  doCheck = false;

  meta = with lib; {
    description = "Improve performance of Emacs LSP servers by converting JSON to bytecode";
    homepage = "https://github.com/${src.owner}/${pname}";
    changelog = "https://github.com/${src.owner}/${pname}/releases/tag/${version}";
    license = [ licenses.mit ];
    mainProgram = "emacs-lsp-booster";
  };
}
