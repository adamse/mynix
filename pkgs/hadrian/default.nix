{ stdenv, git, runCommand }:

let
  script = ''
    #!${stdenv.shell}


    if ! TOP=$(${git}/bin/git rev-parse --show-toplevel); then
      exit 1
    fi
    pushd "$TOP"
    ./hadrian/build "$@"
    popd
  '';
in

runCommand "hadrian" {
  inherit script;
  passAsFile = [ "script" ];
} ''
  mkdir -p $out/bin
  substitute $scriptPath $out/bin/hadrian
  chmod +x $out/bin/hadrian
''
