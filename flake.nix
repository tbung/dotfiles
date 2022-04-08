{
  description = "A very basic flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, darwin, neovim-nightly-overlay }@inputs:
    {

      darwinConfigurations = {

        # DKFZ MacBook
        e230-mb001 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          inherit inputs;
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ./nix/system/darwin.nix
          ];
        };

      };

      homeConfigurations = {

        # DKFZ Workstation
        e230-pc33 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          username = "t974t";
          homeDirectory = "/home/t974t";
          extraSpecialArgs = { inherit inputs; };
          configuration = import ./nix/home/anylinux.nix;
          stateVersion = "22.05";
        };

        # Wireguard VPN Server

      };

      nixosConfigurations = {

        # Main Workstation
        deep-thought = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.home-manager.nixosModule
            ./nix/hosts/deep-thought
          ];
        };

        # Home Hub

      };

    };
}
