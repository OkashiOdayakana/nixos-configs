{ pkgs, lib, ...}:
{
  services.thermald.enable = true;
  services.tlp.enable = true;
}
