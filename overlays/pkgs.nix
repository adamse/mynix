pkgs: prev:
{
  magit = pkgs.callPackage ../pkgs/magit {};
  nixify = pkgs.callPackage ../pkgs/nixify {};
}
