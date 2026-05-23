{
  description = "jos NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.jos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/jos/default.nix
        ./hosts/jos/hardware.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs        = true;
          home-manager.useUserPackages      = true;
          home-manager.extraSpecialArgs     = { inherit inputs; };
          home-manager.backupFileExtension  = "bak";
          home-manager.users.jos            = import ./home/jos.nix;
        }
      ];
    };
  };
}
