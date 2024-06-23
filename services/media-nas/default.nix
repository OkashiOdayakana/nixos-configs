{ config, pkgs, libs, ...}:
{
  imports = [
    ./arrs.nix
    ./jellyfin.nix
    ./transmission.nix
    ./flaresolverr.nix
  ];
}
