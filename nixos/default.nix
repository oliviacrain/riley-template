{
  inputs,
  outputs,
  ...
}: let
  mkSystem = name: system: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs;
      };
      modules = [./${name}/configuration.nix];
    };
  };
in
  mkSystem "hostname" "aarch64-linux"
