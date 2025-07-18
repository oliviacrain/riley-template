{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  hostname = "hostname";
  username = "riley";
  ssh_pubkey = "put key here";
in {
  imports = [
    inputs.asahi.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
  ];

  # Don't change
  system.stateVersion = "25.05";

  # Set up your user
  users.users.${username} = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ ssh_pubkey ];
    home = "/home/${username}";
    packages = with pkgs; [
      # whatever pages you want to have available to only your user
    ];
    # https://github.com/nix-community/home-manager
    # Note: You can use home-manager for dotfile management
  };

  # Networking settings
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Desktop config- I went with KDE Plasma 6, but use whatever you want
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Electron bullshit
  hardware.bluetooth.enable = true;
  services.dbus.implementation = "broker";

  # Any packages you want available in system-wide PATH can go here
  environment.systemPackages = with pkgs; [
    vim
    firefox
    git
    wl-clipboard
  ];

  # Asahi shit
  hardware.asahi = {
    enable = true;
    useExperimentalGPUDriver = true;
  };

  # Nix configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ];
  };

  # booooooot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    initrd.systemd.enable = true;
  };

  # Chicago baybeeeeee
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
