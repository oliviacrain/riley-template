{
  inputs = {
    # Can also replace "nixos-unstable" with "nixos-25.05" for the stable channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    asahi = {
      url = "github:nix-community/nixos-apple-silicon/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
      self,
      nixpkgs,
      ...
    } @ inputs: let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgs = forAllSystems (
        system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
      );

    in {
      nixosConfigurations = import ./nixos {inherit inputs outputs;};
    };
}
