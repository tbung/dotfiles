{
  description = "A very basic flake";

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

      darwinConfigurations."e230-mb001" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          inputs.home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
          }
          ./nix/hosts/e230-mb001.nix
        ];
      };

      homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
        username = "t974t";
        homeDirectory = "/home/t974t";
        # Specify the path to your home configuration here
        configuration = { pkgs, config, ... }:
          {
            imports = [
              {
                nixpkgs = {
                  overlays = [ neovim-nightly-overlay.overlay ];
                  config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
                    "obsidian"
                    "vscode"
                    "slack"
                    "zoom"
                    "spotify"
                    "spotify-unwrapped"
                  ];
                };
              }
              ./nix/linux.nix
            ];
          };

        system = "x86_64-linux";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "22.05";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

      nixosConfigurations.deep-thought = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
          }
          ./nix/hosts/deep-thought/configuration.nix
        ];
      };
    
    };
}
