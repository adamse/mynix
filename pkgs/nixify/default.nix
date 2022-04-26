{ direnv, stdenv, runCommand, writeScriptBin }:

let
  defaultShellNix = ''
    { pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      buildInputs = [ ];
    }
  '';
  script = ''
    #!${stdenv.shell}

    if [ ! -f ./shell.nix -a ! -f ./default.nix ]; then
      cp @out@/shell.nix ./shell.nix
      chmod u+w ./shell.nix
    fi

    echo "use_nix" > .envrc
    ${direnv}/bin/direnv allow .
  '';

in

runCommand "nixify" {
  inherit script defaultShellNix;
  passAsFile = [ "script" "defaultShellNix" ];
} ''
  mkdir -p $out/bin
  substitute $scriptPath $out/bin/nixify --subst-var out
  chmod +x $out/bin/nixify
  cp $defaultShellNixPath $out/shell.nix
''
