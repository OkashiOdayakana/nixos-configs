{ pkgs, lib, ... }:

{
  networking.nameservers = ["192.168.1.1"];
  networking.defaultGateway = "192.168.1.1";
  networking.bridges.br0.interfaces = ["enp1s0"];
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      "address" = "192.168.1.5";
      "prefixLength" = 24;
    }];
  };

  # Hostname.
  networking.hostName = "okashitnas";
  #networking.networkmanager.enable = true;



  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 5000 8082 8123 8096 8099 8443 21063 21064 51827 ];
  networking.firewall.allowedUDPPorts = [5353];
  # networking.firewall.allowedUDPPorts = [ ... ];

  #networking.firewall.enable = false;
}
