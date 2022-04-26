pkgs: prev:
{
  magit = pkgs.callPackage ../pkgs/magit {};
  nixify = pkgs.callPackage ../pkgs/nixify {};
  hadrian = pkgs.callPackage ../pkgs/hadrian {};
  bash-bd = pkgs.callPackage ../pkgs/bash-bd {};
  git-haskell-org-hooks = pkgs.callPackage (import ../pkgs/git-haskell-org-hooks {}) {};
}
