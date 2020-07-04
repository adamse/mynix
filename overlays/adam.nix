# https://gist.github.com/LnL7/570349866bb69467d0caf5cb175faa74
pkgs: prev:
{
  userPackages = prev.userPackages or {} // {
    inherit (pkgs)
      # firefox
      # google-chrome
      # chromium
      git
      vim
      neovim
      cabal-install
      direnv
      ripgrep
      shellcheck
      ctags
      tree
      wget
      nix
      smartmontools
      qemu
      nodejs
      cachix
      stylish-haskell
      vlc
      youtube-dl
      magit
      nixify
      niv
      bash-bd
      ;

    ghc = pkgs.haskell.compiler.ghc883;

    fast-tags = pkgs.haskellPackages.fast-tags;

    nix-rebuild = prev.writeScriptBin "nix-rebuild" ''
      #!${prev.stdenv.shell}
      set -e
      if ! command -v nix-env &>/dev/null; then
        echo "warning: nix-env was not found in PATH, add nix to userPackages" >&2
        PATH=${pkgs.nix}/bin:$PATH
      fi
      IFS=- read -r _ oldGen _ <<<"$(readlink "$(readlink ~/.nix-profile)")"
      oldVersions=$(readlink ~/.nix-profile/package_versions || echo "/dev/null")
      nix-env -f '<nixpkgs>' -r -iA userPackages "$@"
      IFS=- read -r _ newGen _ <<<"$(readlink "$(readlink ~/.nix-profile)")"
      ${pkgs.diffutils}/bin/diff --color -u \
        --label "generation $oldGen" $oldVersions \
        --label "generation $newGen" ~/.nix-profile/package_versions \
        || true
    '';

    packageVersions =
      let
        versions = prev.lib.attrsets.mapAttrsToList (_: pkg: pkg.name) pkgs.userPackages;
        versionText = prev.lib.strings.concatMapStrings (s: s+"\n") versions;
      in
        prev.writeTextDir "package_versions" versionText;
  };
}
