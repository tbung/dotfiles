{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  outputs = { self, nixpkgs }: rec {
    nixosConfigurations.rpi1 = nixpkgs.lib.nixosSystem {
      system = "armv6l-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        {
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.crossSystem.system = "armv6l-linux";
          # ... extra configs as above
        }
      ];
    };
    images.rpi1 = nixosConfigurations.rpi1.config.system.build.sdImage;
  };
}
