{ source-emacs-lsp-booster, rustPlatform, lib, ... }:

rustPlatform.buildRustPackage rec {
  inherit (source-emacs-lsp-booster) src;

  pname = "emacs-lsp-booster";
  version = "0.2.1";

  cargoHash = "sha256-CvIJ56QrIzQULFeXYQXTpX9PoGx1/DWtgwzfJ+mljEI=";

  # The tests contain what are essentially benchmarks—it seems prudent not to
  # stress our users' computers in that way every time they build the package.
  doCheck = false;

  meta = with lib; {
    description = "Improve performance of Emacs LSP servers by converting JSON to bytecode";
    homepage = "https://github.com/${src.owner}/${pname}";
    changelog = "https://github.com/${src.owner}/${pname}/releases/tag/${version}";
    license = [ licenses.mit ];
    maintainers = [];
    mainProgram = "emacs-lsp-booster";
  };
}
