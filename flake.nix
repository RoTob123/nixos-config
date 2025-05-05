{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixcats.url = "/home/rewind/.config/nvim";

    nvf.url = "github:notashelf/nvf";

    stylix.url = "github:danth/stylix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixcats, nvf, ... }@inputs: {

    nixosConfigurations.nixrewind = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        nvf.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
