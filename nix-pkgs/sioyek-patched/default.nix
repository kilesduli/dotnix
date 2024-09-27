{ sioyek, fetchurl, fetchFromGitHub, lib, ... }:

sioyek.overrideAttrs (
  old: {
    src = fetchFromGitHub {
      owner = "ahrm";
      repo = "sioyek";
      rev = "7181c5a463ed4cbeda7ab4937511bdfc836d6c94";
      sha256 = "sha256-lHKB9jchsRYjgF7KJdlDTpKVZGP8lq1btmTt3ud67wM=";
    };
    patches = (fetchurl {
      url = "https://gist.githubusercontent.com/tennysontbardwell/70bac2f20946e9609686866faa188aea/raw/d84c577d58bc37436147d855984f5a66a4e0988a/mupdf-0.23.0-rev-277aed7.patch";
      hash = "sha256-Gajno8+qdWIuYQWiu0/yY2YzJ6nR97pkjwhY1bEflIA=";
    });
  }
)
