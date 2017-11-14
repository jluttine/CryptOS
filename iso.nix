# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{lib, config, pkgs, ...}:
with lib;
{
  imports = [

    # Support as many devices as possible
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>

    # Install KDE Plasma
    <nixpkgs/nixos/modules/profiles/graphical.nix>

    <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>
    #<nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    #<nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # ISO naming.
  isoImage.isoBaseName = "cryptos";
  #isoImage.isoName = "${config.isoImage.isoBaseName}-${config.system.nixosLabel}-${pkgs.stdenv.system}.iso";
  isoImage.volumeID = substring 0 11 "CRYPTOS_ISO";

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  # Add Memtest86+ to the CD.
  #boot.loader.grub.memtest86.enable = true;

  # Disable networking
  networking = {
    networkmanager.enable = false;
    wireless.enable = false;
    useDHCP = false;
    interfaces = {};
  };

  # Allow the user to log in as root without a password.
  users.extraUsers.root.initialHashedPassword = "";

  isoImage.splashImage = pkgs.fetchurl {
    url = https://raw.githubusercontent.com/NixOS/nixos-artwork/5729ab16c6a5793c10a2913b5a1b3f59b91c36ee/ideas/grub-splash/grub-nixos-1.png;
    sha256 = "43fd8ad5decf6c23c87e9026170a13588c2eba249d9013cb9f888da5e2002217";
  };

  isoImage.appendToMenuLabel = " Live System";

  environment.systemPackages = with pkgs; [
    electrum
    monero
  ];

}
