You'll want to clone this and change the following:
- variables in the top-level "let" block in the `nixos/hostname/configuration.nix` file
- the folder name "nixos/hostname" (make it match your hostname)
- the string "hostname" on the last line of `nixos/default.nix`
- replace `nixos/hostname/hardware-configuration.nix` with the one you've already generated

You can test-build the system with `nix --extra-experimental-features "nix-command flakes" build .#nixosConfigurations.<your hostname>.config.system.build.top-level`

You can switch nixos configs using `nixos-rebuild --flake <path to this repo>#<your hostname>`

You can update the pinned nixpkgs revision with `nix flake update` once you get things going.
