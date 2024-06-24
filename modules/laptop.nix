{ pkgs, lib, ...}:
{
  services.thermald.enable = true;
  services.tlp.enable = true;
  networking.networkmanager.enable = true;
  users.users.okashi.extraGroups = [ "networkmanager" ];
}
