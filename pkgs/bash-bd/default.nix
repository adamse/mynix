{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "bash-bd";
  version = "2020-06-04";

  src = fetchFromGitHub {
    owner = "vigneshwaranr";
    repo = "bd";
    rev = "c497fe7d85ec13e75c087a0fc64e67eeb4a24b0c";
    sha256 = "09hrnl3cik9b1saz9awf96havdlxlgd7gyqil9dzl7ml2xl7hrc1";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/etc/bash_completion.d
    cp $src/bash_completion.d/bd $out/etc/bash_completion.d/
    cp $src/bd $out/bin/
  '';
}
