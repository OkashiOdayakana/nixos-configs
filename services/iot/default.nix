{ inputs, config, pkgs, lib, ...}:
  {
    imports = [
      ./iot-web.nix
      ./frigate.nix
      ./home-assistant.nix
    ];
    services.unifi = {
      enable = true;
      unifiPackage = pkgs.unifi8;
    };
  }
