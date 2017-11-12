# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{lib, config, pkgs, ...}:
with lib;
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # ISO naming.
  isoImage.isoBaseName = "cryptos";
  #isoImage.isoName = "${config.isoImage.isoBaseName}-${config.system.nixosLabel}-${pkgs.stdenv.system}.iso";
  isoImage.volumeID = substring 0 11 "CRYPTOS_ISO";

  environment.systemPackages = with pkgs; [
    electrum
    monero
  ];
}
