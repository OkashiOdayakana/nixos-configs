{ pkgs, lib, ...}:
{
  services.thermald.enable = true;
  networking.networkmanager.enable = true;
  users.users.okashi.extraGroups = [ "networkmanager" ];
}
