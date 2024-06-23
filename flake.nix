{
  description = "Okashi's NixOS flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      okashitnas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};

        modules = [
          ./hosts/okashitnas
          sops-nix.nixosModules.sops
          {
            sops = {
              defaultSopsFile = ./secrets/secrets.yaml;
              age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
              secrets = {
                "iot/mqtt/frigate" = {};
                "iot/frigate-cam" = {};
                "iot/mqtt/zigbee2mqtt.yaml" = {};
                "vpn/protonvpn/privateKey" = {};
                "media/transmission/creds.json" = {};
              };
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.okashi = import ./home;
          }
        ];
      };
    };
  };
}

